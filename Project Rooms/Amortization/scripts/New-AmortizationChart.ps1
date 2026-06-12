param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,

    [Parameter(Mandatory = $true)]
    [string]$ProjectSpreadsheetPath,

    [Parameter(Mandatory = $true)]
    [string]$CallerDestinationFolder,

    [ValidateSet("PDF", "XLSX", "Both")]
    [string]$OutputFormat = "PDF",

    [string]$ProjectRoom = "C:\Codex\Wiki Files\Project Rooms\Amortization"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression

$templatePath = Join-Path $ProjectRoom "templates\Buyer-Facing Amortization Chart Template.xlsx"
$sofficePath = "C:\Program Files\LibreOffice\program\soffice.exe"

function ConvertTo-SafeFileName {
    param([string]$Name)
    $invalid = [System.IO.Path]::GetInvalidFileNameChars()
    $safe = $Name
    foreach ($char in $invalid) {
        $safe = $safe.Replace([string]$char, "-")
    }
    return ($safe -replace "\s+", " ").Trim()
}

function Read-ZipEntryText {
    param($Zip, [string]$Path)
    $entry = $Zip.GetEntry($Path)
    if ($null -eq $entry) {
        return $null
    }
    $reader = New-Object System.IO.StreamReader($entry.Open())
    try {
        return $reader.ReadToEnd()
    } finally {
        $reader.Dispose()
    }
}

function Open-ZipReadShared {
    param([string]$Path)
    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    try {
        return [System.IO.Compression.ZipArchive]::new($stream, [System.IO.Compression.ZipArchiveMode]::Read, $false)
    } catch {
        $stream.Dispose()
        throw
    }
}

function Write-ZipEntryText {
    param($Zip, [string]$Path, [string]$Text)
    $old = $Zip.GetEntry($Path)
    if ($null -ne $old) {
        $old.Delete()
    }
    $entry = $Zip.CreateEntry($Path)
    $writer = New-Object System.IO.StreamWriter($entry.Open())
    try {
        $writer.Write($Text)
    } finally {
        $writer.Dispose()
    }
}

function Get-NextDocumentVersion {
    param([string]$ProjectRoom)
    $versionDate = Get-Date -Format "yy-MM-dd"
    $registerPath = Join-Path $ProjectRoom "working\version-register.csv"
    $maxVersion = 0
    if (Test-Path -LiteralPath $registerPath) {
        foreach ($entry in (Import-Csv -LiteralPath $registerPath)) {
            if ($entry.workflow -ne "Amortization" -or $entry.date -ne $versionDate) {
                continue
            }
            if ($entry.document_version -match "V([0-9]+)$") {
                $candidate = [int]$Matches[1]
                if ($candidate -gt $maxVersion) {
                    $maxVersion = $candidate
                }
            }
        }
    }
    return "$versionDate V$($maxVersion + 1)"
}

function Add-VersionRegisterEntry {
    param(
        [string]$ProjectRoom,
        [string]$ProjectName,
        [string]$DocumentVersion,
        [string]$RoomPdfPath,
        [string]$CallerPdfPath
    )
    $registerPath = Join-Path $ProjectRoom "working\version-register.csv"
    $registerFolder = Split-Path -Parent $registerPath
    New-Item -ItemType Directory -Force -Path $registerFolder | Out-Null
    $columns = @("workflow", "date", "document_version", "project_name", "created_at", "room_pdf", "caller_pdf")
    if (Test-Path -LiteralPath $registerPath) {
        $existingEntries = Import-Csv -LiteralPath $registerPath
        $existingEntries | Select-Object $columns | Export-Csv -LiteralPath $registerPath -NoTypeInformation
    }
    $entry = [pscustomobject]@{
        workflow = "Amortization"
        date = (Get-Date -Format "yy-MM-dd")
        document_version = $DocumentVersion
        project_name = $ProjectName
        created_at = (Get-Date).ToString("s")
        room_pdf = $RoomPdfPath
        caller_pdf = $CallerPdfPath
    }
    if (Test-Path -LiteralPath $registerPath) {
        $entry | Export-Csv -LiteralPath $registerPath -NoTypeInformation -Append
    } else {
        $entry | Export-Csv -LiteralPath $registerPath -NoTypeInformation
    }
}

function Get-SharedStrings {
    param($Zip)
    $text = Read-ZipEntryText $Zip "xl/sharedStrings.xml"
    if ($null -eq $text) {
        return @()
    }
    [xml]$xml = $text
    $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
    $ns.AddNamespace("x", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
    $items = @()
    foreach ($si in $xml.SelectNodes("//x:si", $ns)) {
        $parts = @()
        foreach ($t in $si.SelectNodes(".//x:t", $ns)) {
            $parts += $t.InnerText
        }
        $items += ($parts -join "")
    }
    return $items
}

function Get-SheetPath {
    param($Zip, [string[]]$Names)
    [xml]$workbook = Read-ZipEntryText $Zip "xl/workbook.xml"
    [xml]$rels = Read-ZipEntryText $Zip "xl/_rels/workbook.xml.rels"
    $wbNs = New-Object System.Xml.XmlNamespaceManager($workbook.NameTable)
    $wbNs.AddNamespace("x", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
    $wbNs.AddNamespace("r", "http://schemas.openxmlformats.org/officeDocument/2006/relationships")
    $relNs = New-Object System.Xml.XmlNamespaceManager($rels.NameTable)
    $relNs.AddNamespace("rel", "http://schemas.openxmlformats.org/package/2006/relationships")

    foreach ($name in $Names) {
        foreach ($sheet in $workbook.SelectNodes("//x:sheets/x:sheet", $wbNs)) {
            if ($sheet.GetAttribute("name") -eq $name) {
                $id = $sheet.GetAttribute("id", "http://schemas.openxmlformats.org/officeDocument/2006/relationships")
                $rel = $rels.SelectSingleNode("//rel:Relationship[@Id='$id']", $relNs)
                if ($null -eq $rel) {
                    throw "Relationship not found for worksheet '$name'."
                }
                $target = $rel.GetAttribute("Target")
                if ($target.StartsWith("/")) {
                    return $target.TrimStart("/")
                }
                return "xl/$target"
            }
        }
    }
    throw "Workbook does not contain worksheet '$($Names -join "' or '")'."
}

function Get-CellNode {
    param([xml]$SheetXml, [string]$Address)
    $ns = New-Object System.Xml.XmlNamespaceManager($SheetXml.NameTable)
    $ns.AddNamespace("x", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
    return $SheetXml.SelectSingleNode("//x:c[@r='$Address']", $ns)
}

function Get-CellValue {
    param([xml]$SheetXml, [string]$Address, [object[]]$SharedStrings)
    $cell = Get-CellNode $SheetXml $Address
    if ($null -eq $cell) {
        return $null
    }
    $type = $cell.GetAttribute("t")
    if ($type -eq "s") {
        $v = $cell.SelectSingleNode("*[local-name()='v']")
        if ($null -eq $v) { return $null }
        return [string]$SharedStrings[[int]$v.InnerText]
    }
    if ($type -eq "inlineStr") {
        $texts = $cell.SelectNodes(".//*[local-name()='t']")
        $parts = @()
        foreach ($t in $texts) { $parts += $t.InnerText }
        return ($parts -join "")
    }
    $valueNode = $cell.SelectSingleNode("*[local-name()='v']")
    if ($null -eq $valueNode) {
        return $null
    }
    return [string]$valueNode.InnerText
}

function Convert-ExcelSerialDate {
    param([object]$Value, [string]$Format)
    if ($null -eq $Value -or [string]::IsNullOrWhiteSpace([string]$Value)) {
        return ""
    }
    $number = 0.0
    if ([double]::TryParse([string]$Value, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$number)) {
        return ([datetime]"1899-12-30").AddDays($number).ToString($Format, [System.Globalization.CultureInfo]::InvariantCulture)
    }
    return [string]$Value
}

function Get-NumberValue {
    param([xml]$SheetXml, [string]$Address, [object[]]$SharedStrings)
    $raw = Get-CellValue $SheetXml $Address $SharedStrings
    if ($null -eq $raw -or [string]::IsNullOrWhiteSpace([string]$raw)) {
        return $null
    }
    $number = 0.0
    if (-not [double]::TryParse([string]$raw, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$number)) {
        return $null
    }
    return $number
}

function Format-InvariantNumber {
    param([double]$Value)
    return $Value.ToString("0.############", [System.Globalization.CultureInfo]::InvariantCulture)
}

function Get-ColumnName {
    param([int]$ColumnNumber)
    $name = ""
    while ($ColumnNumber -gt 0) {
        $mod = ($ColumnNumber - 1) % 26
        $name = [char](65 + $mod) + $name
        $ColumnNumber = [math]::Floor(($ColumnNumber - $mod) / 26)
    }
    return $name
}

function Get-ColumnNumber {
    param([string]$ColumnName)
    $number = 0
    foreach ($char in $ColumnName.ToUpperInvariant().ToCharArray()) {
        $number = ($number * 26) + ([int][char]$char - [int][char]'A' + 1)
    }
    return $number
}

function Split-CellAddress {
    param([string]$Address)
    if ($Address -notmatch "^([A-Z]+)([0-9]+)$") {
        throw "Invalid cell address: $Address"
    }
    return @{
        ColumnName = $Matches[1]
        Column = Get-ColumnNumber $Matches[1]
        Row = [int]$Matches[2]
    }
}

function Ensure-Cell {
    param([xml]$SheetXml, [string]$Address)
    $cell = Get-CellNode $SheetXml $Address
    if ($null -ne $cell) {
        return $cell
    }
    $parts = Split-CellAddress $Address
    $ns = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    $sheetData = $SheetXml.DocumentElement.SelectSingleNode("*[local-name()='sheetData']")
    $rowNode = $SheetXml.SelectSingleNode("//*[local-name()='row' and @r='$($parts.Row)']")
    if ($null -eq $rowNode) {
        $rowNode = $SheetXml.CreateElement("row", $ns)
        $rowNode.SetAttribute("r", [string]$parts.Row)
        [void]$sheetData.AppendChild($rowNode)
    }
    $cell = $SheetXml.CreateElement("c", $ns)
    $cell.SetAttribute("r", $Address)
    [void]$rowNode.AppendChild($cell)
    return $cell
}

function Clear-CellChildren {
    param($Cell)
    while ($Cell.ChildNodes.Count -gt 0) {
        [void]$Cell.RemoveChild($Cell.ChildNodes.Item(0))
    }
}

function Set-CellString {
    param([xml]$SheetXml, [string]$Address, [string]$Value)
    $cell = Ensure-Cell $SheetXml $Address
    $cell.SetAttribute("t", "inlineStr")
    Clear-CellChildren $cell
    $is = $SheetXml.CreateElement("is", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
    $t = $SheetXml.CreateElement("t", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
    $t.InnerText = $Value
    [void]$is.AppendChild($t)
    [void]$cell.AppendChild($is)
}

function Set-CellNumber {
    param([xml]$SheetXml, [string]$Address, [double]$Value)
    $cell = Ensure-Cell $SheetXml $Address
    if ($cell.HasAttribute("t")) {
        $cell.RemoveAttribute("t")
    }
    Clear-CellChildren $cell
    $v = $SheetXml.CreateElement("v", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
    $v.InnerText = Format-InvariantNumber $Value
    [void]$cell.AppendChild($v)
}

function Set-WorksheetFooter {
    param([xml]$SheetXml, [string]$DocumentVersion)
    $spreadsheetNs = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    $existing = $SheetXml.DocumentElement.SelectSingleNode("*[local-name()='headerFooter']")
    if ($null -ne $existing) {
        [void]$SheetXml.DocumentElement.RemoveChild($existing)
    }
    $headerFooter = $SheetXml.CreateElement("headerFooter", $spreadsheetNs)
    $oddFooter = $SheetXml.CreateElement("oddFooter", $spreadsheetNs)
    $oddFooter.InnerText = "Page &P of &N | $DocumentVersion"
    [void]$headerFooter.AppendChild($oddFooter)
    [void]$SheetXml.DocumentElement.AppendChild($headerFooter)
}

function Find-LabelValue {
    param([xml]$SheetXml, [object[]]$SharedStrings, [string[]]$Patterns)
    if ($null -eq $SheetXml) {
        return ""
    }
    $cells = $SheetXml.SelectNodes("//*[local-name()='c']")
    foreach ($cell in $cells) {
        $address = $cell.GetAttribute("r")
        $text = Get-CellValue $SheetXml $address $SharedStrings
        if ([string]::IsNullOrWhiteSpace([string]$text)) {
            continue
        }
        foreach ($pattern in $Patterns) {
            if ([string]$text -match $pattern) {
                $parts = Split-CellAddress $address
                for ($offset = 1; $offset -le 4; $offset++) {
                    $candidateAddress = (Get-ColumnName ($parts.Column + $offset)) + $parts.Row
                    $candidate = Get-CellValue $SheetXml $candidateAddress $SharedStrings
                    if (-not [string]::IsNullOrWhiteSpace([string]$candidate)) {
                        return ([string]$candidate).Trim()
                    }
                }
            }
        }
    }
    return ""
}

function Require-Text {
    param([string]$Name, [string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        throw "Missing required source data: $Name."
    }
}

function Require-Number {
    param([string]$Name, $Value)
    if ($null -eq $Value) {
        throw "Missing required source data: $Name."
    }
}

function Find-FirstPaymentRow {
    param([xml]$SheetXml, [object[]]$SharedStrings)
    for ($row = 16; $row -le 1200; $row++) {
        $dateText = Get-CellValue $SheetXml "X$row" $SharedStrings
        $scheduledPayment = Get-NumberValue $SheetXml "AA$row" $SharedStrings
        $totalPayment = Get-NumberValue $SheetXml "AF$row" $SharedStrings
        if (-not [string]::IsNullOrWhiteSpace([string]$dateText) -and
            (($scheduledPayment -ne $null -and [math]::Abs($scheduledPayment) -gt 0.005) -or
             ($totalPayment -ne $null -and [math]::Abs($totalPayment) -gt 0.005))) {
            return $row
        }
    }
    throw "Could not find the first scheduled seller-financing payment row on the amortization worksheet."
}

function Convert-WithLibreOffice {
    param([string]$WorkbookPath, [string]$OutDir)
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $loSafeRoot = Join-Path $env:TEMP ("amortization-lo-" + [guid]::NewGuid().ToString("N"))
    $profilePath = Join-Path $loSafeRoot "profile"
    New-Item -ItemType Directory -Force -Path $loSafeRoot, $profilePath | Out-Null
    $safeWorkbook = Join-Path $loSafeRoot "amortization-chart.xlsx"
    Copy-Item -LiteralPath $WorkbookPath -Destination $safeWorkbook -Force
    $profileUri = ([uri]$profilePath).AbsoluteUri
    $args = @(
        "-env:UserInstallation=$profileUri",
        "--headless",
        "--norestore",
        "--nofirststartwizard",
        "--convert-to", "pdf",
        "--outdir", $loSafeRoot,
        $safeWorkbook
    )
    try {
        $process = Start-Process -FilePath $sofficePath -ArgumentList $args -PassThru -WindowStyle Hidden
        if (-not $process.WaitForExit(240000)) {
            try { $process.Kill() } catch {}
            throw "LibreOffice PDF export timed out."
        }
        if ($process.ExitCode -ne 0) {
            throw "LibreOffice PDF export failed with exit code $($process.ExitCode)."
        }
        $safePdf = Join-Path $loSafeRoot "amortization-chart.pdf"
        if (-not (Test-Path -LiteralPath $safePdf)) {
            throw "LibreOffice did not create expected PDF: $safePdf"
        }
        $pdf = Join-Path $OutDir ([System.IO.Path]::GetFileNameWithoutExtension($WorkbookPath) + ".pdf")
        Copy-Item -LiteralPath $safePdf -Destination $pdf -Force
        return $pdf
    } finally {
        Remove-Item -LiteralPath $loSafeRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}

if (-not (Test-Path -LiteralPath $ProjectSpreadsheetPath)) {
    throw "Project spreadsheet not found: $ProjectSpreadsheetPath"
}
if (-not (Test-Path -LiteralPath $templatePath)) {
    throw "Buyer-facing template workbook not found: $templatePath"
}
if (-not (Test-Path -LiteralPath $sofficePath)) {
    throw "LibreOffice not found: $sofficePath"
}

$safeName = ConvertTo-SafeFileName $ProjectName
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$runRoot = Join-Path $ProjectRoom "working\runs\$stamp-$safeName"
$roomOutputFolder = Join-Path $ProjectRoom "outputs\$safeName"
New-Item -ItemType Directory -Force -Path $runRoot, $roomOutputFolder, $CallerDestinationFolder | Out-Null

$workingWorkbook = Join-Path $runRoot "$safeName - 12 Month Amortization Chart.xlsx"
$roomPdfPath = Join-Path $roomOutputFolder "$safeName - 12 Month Amortization Chart.pdf"
$callerPdfPath = Join-Path $CallerDestinationFolder "$safeName - 12 Month Amortization Chart.pdf"
$callerWorkbookPath = Join-Path $CallerDestinationFolder "$safeName - 12 Month Amortization Chart.xlsx"
$documentVersion = Get-NextDocumentVersion $ProjectRoom
Copy-Item -LiteralPath $templatePath -Destination $workingWorkbook -Force

$sourceZip = Open-ZipReadShared $ProjectSpreadsheetPath
try {
    $sourceSharedStrings = Get-SharedStrings $sourceZip
    $sourceSheetPath = Get-SheetPath $sourceZip @("Amortization", "amateurization")
    $worksheetUsed = if ($sourceSheetPath) {
        [xml]$sourceWorkbookXml = Read-ZipEntryText $sourceZip "xl/workbook.xml"
        $ns = New-Object System.Xml.XmlNamespaceManager($sourceWorkbookXml.NameTable)
        $ns.AddNamespace("x", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
        $sheetNode = $sourceWorkbookXml.SelectNodes("//x:sheets/x:sheet", $ns) | Where-Object {
            $name = $_.GetAttribute("name")
            ($name -eq "Amortization" -or $name -eq "amateurization")
        } | Select-Object -First 1
        $sheetNode.GetAttribute("name")
    }
    [xml]$sourceSheet = Read-ZipEntryText $sourceZip $sourceSheetPath
    $docsSheet = $null
    try {
        $docsSheetPath = Get-SheetPath $sourceZip @("Docs")
        [xml]$docsSheet = Read-ZipEntryText $sourceZip $docsSheetPath
    } catch {}

    $firstPaymentRow = Find-FirstPaymentRow $sourceSheet $sourceSharedStrings
    $paymentRows = @()

    $buyer1 = Find-LabelValue $docsSheet $sourceSharedStrings @("Selling[- ]?Buyer1", "Selling.*Buyer.*1", "^Buyer\s*1", "^Buyer1")
    $buyer2 = Find-LabelValue $docsSheet $sourceSharedStrings @("Selling[- ]?Buyer2", "Selling.*Buyer.*2", "^Buyer\s*2", "^Buyer2")
    $buyerNames = @($buyer1, $buyer2) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    $buyerName = ($buyerNames -join " / ")
    if ([string]::IsNullOrWhiteSpace($buyerName)) {
        $buyerName = Find-LabelValue $docsSheet $sourceSharedStrings @("Buyer", "Purchaser")
    }

    $property = $ProjectName
    $contractDate = Convert-ExcelSerialDate (Get-CellValue $sourceSheet "O11" $sourceSharedStrings) "M/d/yyyy"
    $saleAmount = Get-CellValue $sourceSheet "AA4" $sourceSharedStrings
    $downPayment = Get-CellValue $sourceSheet "AA5" $sourceSharedStrings
    $loanAmount = Get-CellValue $sourceSheet "AA6" $sourceSharedStrings
    $buyerRateRaw = Get-NumberValue $sourceSheet "Z$firstPaymentRow" $sourceSharedStrings
    $monthlyTotalRaw = Get-NumberValue $sourceSheet "AF$firstPaymentRow" $sourceSharedStrings
    $buyerRate = if ($buyerRateRaw -ne $null) { $buyerRateRaw.ToString("0.00%", [System.Globalization.CultureInfo]::InvariantCulture) } else { "" }
    $monthlyTotalPayment = if ($monthlyTotalRaw -ne $null) { $monthlyTotalRaw.ToString("#,##0", [System.Globalization.CultureInfo]::InvariantCulture) } else { "" }

    Require-Text "buyer name(s)" $buyerName
    Require-Text "property" $property
    Require-Text "contract date" $contractDate
    Require-Text "sale amount" $saleAmount
    Require-Text "down payment" $downPayment
    Require-Text "loan amount" $loanAmount
    Require-Text "buyer rate" $buyerRate
    Require-Text "monthly total payment" $monthlyTotalPayment

    for ($index = 0; $index -lt 12; $index++) {
        $sourceRow = $firstPaymentRow + $index
        $dateText = Convert-ExcelSerialDate (Get-CellValue $sourceSheet "X$sourceRow" $sourceSharedStrings) "MMM-yy"
        $beginningBalance = Get-NumberValue $sourceSheet "Y$sourceRow" $sourceSharedStrings
        $interestRate = Get-NumberValue $sourceSheet "Z$sourceRow" $sourceSharedStrings
        $scheduledPayment = Get-NumberValue $sourceSheet "AA$sourceRow" $sourceSharedStrings
        $principal = Get-NumberValue $sourceSheet "AB$sourceRow" $sourceSharedStrings
        $interest = Get-NumberValue $sourceSheet "AC$sourceRow" $sourceSharedStrings
        $insurance = Get-NumberValue $sourceSheet "AD$sourceRow" $sourceSharedStrings
        $taxes = Get-NumberValue $sourceSheet "AE$sourceRow" $sourceSharedStrings
        $totalPayment = Get-NumberValue $sourceSheet "AF$sourceRow" $sourceSharedStrings
        $endingBalance = Get-NumberValue $sourceSheet "AL$sourceRow" $sourceSharedStrings

        Require-Text "payment date row $sourceRow" $dateText
        Require-Number "beginning balance row $sourceRow" $beginningBalance
        Require-Number "interest rate row $sourceRow" $interestRate
        Require-Number "scheduled payment row $sourceRow" $scheduledPayment
        Require-Number "principal row $sourceRow" $principal
        Require-Number "interest row $sourceRow" $interest
        Require-Number "total payment row $sourceRow" $totalPayment
        Require-Number "ending balance row $sourceRow" $endingBalance

        $paymentRows += [ordered]@{
            Number = $index + 1
            Date = $dateText
            BeginningBalance = $beginningBalance
            InterestRate = $interestRate
            ScheduledPayment = $scheduledPayment
            Principal = $principal
            Interest = $interest
            Insurance = if ($null -eq $insurance) { 0 } else { $insurance }
            Taxes = if ($null -eq $taxes) { 0 } else { $taxes }
            TotalPayment = $totalPayment
            EndingBalance = $endingBalance
        }
    }
} finally {
    $sourceZip.Dispose()
}

$outputZip = [System.IO.Compression.ZipFile]::Open($workingWorkbook, [System.IO.Compression.ZipArchiveMode]::Update)
try {
    $outputSharedStrings = Get-SharedStrings $outputZip
    $outputSheetPath = Get-SheetPath $outputZip @("12 Month Chart")
    [xml]$outputSheet = Read-ZipEntryText $outputZip $outputSheetPath

    Set-CellString $outputSheet "A1" "$ProjectName - 12 Month Amortization Chart"
    Set-CellString $outputSheet "C3" $buyerName
    Set-CellString $outputSheet "I3" $property
    Set-CellString $outputSheet "C4" $contractDate
    Set-CellString $outputSheet "I4" $saleAmount
    Set-CellString $outputSheet "C5" $downPayment
    Set-CellString $outputSheet "I5" $loanAmount
    Set-CellString $outputSheet "C6" $buyerRate
    Set-CellString $outputSheet "I6" $monthlyTotalPayment

    foreach ($row in $paymentRows) {
        $targetRow = 8 + $row.Number
        Set-CellNumber $outputSheet "A$targetRow" $row.Number
        Set-CellString $outputSheet "B$targetRow" $row.Date
        Set-CellNumber $outputSheet "C$targetRow" $row.BeginningBalance
        Set-CellNumber $outputSheet "D$targetRow" $row.InterestRate
        Set-CellNumber $outputSheet "E$targetRow" $row.ScheduledPayment
        Set-CellNumber $outputSheet "F$targetRow" $row.Principal
        Set-CellNumber $outputSheet "G$targetRow" $row.Interest
        Set-CellNumber $outputSheet "H$targetRow" $row.Insurance
        Set-CellNumber $outputSheet "I$targetRow" $row.Taxes
        Set-CellNumber $outputSheet "J$targetRow" $row.TotalPayment
        Set-CellNumber $outputSheet "K$targetRow" $row.EndingBalance
    }

    $sumScheduledPayment = 0.0
    $sumPrincipal = 0.0
    $sumInterest = 0.0
    $sumInsurance = 0.0
    $sumTaxes = 0.0
    $sumTotalPayment = 0.0
    foreach ($row in $paymentRows) {
        $sumScheduledPayment += [double]$row.ScheduledPayment
        $sumPrincipal += [double]$row.Principal
        $sumInterest += [double]$row.Interest
        $sumInsurance += [double]$row.Insurance
        $sumTaxes += [double]$row.Taxes
        $sumTotalPayment += [double]$row.TotalPayment
    }
    Set-CellNumber $outputSheet "E21" $sumScheduledPayment
    Set-CellNumber $outputSheet "F21" $sumPrincipal
    Set-CellNumber $outputSheet "G21" $sumInterest
    Set-CellNumber $outputSheet "H21" $sumInsurance
    Set-CellNumber $outputSheet "I21" $sumTaxes
    Set-CellNumber $outputSheet "J21" $sumTotalPayment

    Set-WorksheetFooter $outputSheet $documentVersion
    Write-ZipEntryText $outputZip $outputSheetPath $outputSheet.OuterXml
} finally {
    $outputZip.Dispose()
}

$loOutDir = Join-Path $runRoot "pdf"
$generatedPdf = Convert-WithLibreOffice $workingWorkbook $loOutDir
Copy-Item -LiteralPath $generatedPdf -Destination $roomPdfPath -Force
Copy-Item -LiteralPath $roomPdfPath -Destination $callerPdfPath -Force

if ($OutputFormat -in @("XLSX", "Both")) {
    Copy-Item -LiteralPath $workingWorkbook -Destination $callerWorkbookPath -Force
}

$roomPdf = Get-Item -LiteralPath $roomPdfPath
$callerPdf = Get-Item -LiteralPath $callerPdfPath
if ($roomPdf.Length -le 0) {
    throw "Created project-room PDF is empty: $roomPdfPath"
}
if ($callerPdf.Length -le 0) {
    throw "Copied caller PDF is empty: $callerPdfPath"
}
if ($paymentRows.Count -ne 12) {
    throw "Expected 12 payment rows, found $($paymentRows.Count)."
}

Add-VersionRegisterEntry $ProjectRoom $ProjectName $documentVersion $roomPdfPath $callerPdfPath

$result = [ordered]@{
    project_name = $ProjectName
    worksheet_used = $worksheetUsed
    document_version = $documentVersion
    footer = "Page X of Y | $documentVersion"
    amortization_project_room_pdf = $roomPdfPath
    caller_pdf = $callerPdfPath
    working_workbook = $workingWorkbook
    copied_workbook = if ($OutputFormat -in @("XLSX", "Both")) { $callerWorkbookPath } else { $null }
    first_payment_date = $paymentRows[0].Date
    last_payment_date = $paymentRows[-1].Date
    payment_rows = $paymentRows.Count
    missing_or_ambiguous_source_data = @()
}

$result | ConvertTo-Json -Depth 5
