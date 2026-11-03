param(
    [Parameter(Mandatory)][ValidateSet('Inspect','Rename','Verify')][string]$Mode,
    [Parameter(Mandatory)][string]$File,
    [Parameter(Mandatory)][string]$Evidence,
    [string]$Output
)
$ErrorActionPreference = 'Stop'
function Digest([string]$Text) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try { [Convert]::ToHexString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($Text))) }
    finally { $sha.Dispose() }
}
function Snapshot($Book) {
    $sheets = [ordered]@{}; $codes = [ordered]@{}; $queries = [ordered]@{}; $names = [ordered]@{}
    foreach ($sheet in $Book.Worksheets) {
        $range = $sheet.UsedRange; $values = $range.Value2
        $text = [Text.StringBuilder]::new(); $errors = @(); $tables = @(); $controls = @()
        if ($values -is [Array] -and $values.Rank -eq 2) {
            for ($r=1; $r -le $values.GetLength(0); $r++) {
                for ($c=1; $c -le $values.GetLength(1); $c++) {
                    $v = $values[$r,$c]
                    if ($sheet.Name -eq 'Gnatt Chart' -and ($r+$range.Row-1) -eq 24 -and ($c+$range.Column-1) -eq 17) { $v='<Paid header>' }
                    $type = if ($null -eq $v) { 'null' } else { $v.GetType().FullName }
                    $value = [Convert]::ToString($v,[Globalization.CultureInfo]::InvariantCulture)
                    [void]$text.Append("$type`:$($value.Length):$value|")
                    if ($v -is [int] -and $v -lt -2000000000) { $errors += "$($r+$range.Row-1),$($c+$range.Column-1):$v" }
                }
            }
        } else { [void]$text.Append([string]$values) }
        foreach ($table in $sheet.ListObjects) {
            $headers=@(); foreach($col in $table.ListColumns){$headers += $col.Name}
            $tables += @{name=$table.Name;address=$table.Range.Address();rows=$table.ListRows.Count;headers=$headers}
        }
        foreach($shape in $sheet.Shapes) {
            $controls += @{name=$shape.Name;type=$shape.Type;left=$shape.Left;top=$shape.Top;width=$shape.Width;height=$shape.Height;action=$shape.OnAction}
        }
        $sheets[$sheet.Name]=@{range=$range.Address();valueHash=(Digest $text.ToString());errors=$errors;tables=$tables;controls=$controls}
    }
    foreach($comp in $Book.VBProject.VBComponents) {
        $cm=$comp.CodeModule; $codes[$comp.Name]=if($cm.CountOfLines){$cm.Lines(1,$cm.CountOfLines)}else{''}
    }
    foreach($q in $Book.Queries){$queries[$q.Name]=$q.Formula}
    foreach($n in $Book.Names){$names[$n.Name]=$n.RefersTo}
    $grid=$Book.Worksheets.Item('Gnatt Chart'); $table=$grid.ListObjects.Item('Contract_Edits')
    $header=$table.ListColumns.Item(6).Name
    $amounts=@();foreach($v in $table.ListColumns.Item(6).DataBodyRange.Value2){$amounts+=$v}
    $summaries=@{};foreach($addr in @('I2','I3','I4','I5','I6','L2','L3','L4','L5','L6')){$summaries[$addr]=$grid.Range($addr).Value2}
    return @{sheets=$sheets;codes=$codes;queries=$queries;names=$names;paidHeader=$header;paidValues=$amounts;summaries=$summaries;calcMode=$Book.Application.Calculation}
}
$path=$File
if($Mode -eq 'Rename') {
    if(-not $Output -or (Test-Path -LiteralPath $Output)){throw 'A new output path is required.'}
    [void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
    Copy-Item -LiteralPath $File -Destination $Output
    $path=$Output
}
$excel=New-Object -ComObject Excel.Application
$excel.Visible=$false; $excel.DisplayAlerts=$false; $excel.EnableEvents=$false; $excel.AutomationSecurity=3
try {
    $book=$excel.Workbooks.Open($path,0,($Mode -ne 'Rename'))
    $sheet=$book.Worksheets.Item('Gnatt Chart');$table=$sheet.ListObjects.Item('Contract_Edits')
    if($table.HeaderRowRange.Cells.Item(1,6).Address() -ne '$Q$24'){throw 'Unexpected target header location.'}
    $excel.Calculation=-4105; $excel.Calculate()
    $before=Snapshot $book
    if($Mode -eq 'Rename') {
        if($book.ReadOnly -or $table.ListColumns.Item(6).Name -ne '0'){throw 'Expected writable Contract_Edits[0].'}
        $table.ListColumns.Item(6).Name='Paid'
        $excel.Calculate()
        $after=Snapshot $book
        foreach($key in $before.sheets.Keys) {
            if($before.sheets[$key].valueHash -ne $after.sheets[$key].valueHash){throw "Unexpected calculated value change: $key"}
        }
        if(($before.codes|ConvertTo-Json -Depth 8 -Compress) -ne ($after.codes|ConvertTo-Json -Depth 8 -Compress)){throw 'VBA source changed.'}
        if(($before.queries|ConvertTo-Json -Depth 8 -Compress) -ne ($after.queries|ConvertTo-Json -Depth 8 -Compress)){throw 'Query source changed.'}
        $book.Save()
        @{before=$before;after=$after;passed=$true}|ConvertTo-Json -Depth 15|Set-Content -LiteralPath $Evidence -Encoding utf8
    } else {
        if($Mode -eq 'Verify' -and $before.paidHeader -ne 'Paid'){throw 'Paid header missing.'}
        $before|ConvertTo-Json -Depth 15|Set-Content -LiteralPath $Evidence -Encoding utf8
    }
    # Print settings are changed only after saving, then discarded on close.
    $sheet.PageSetup.PrintArea='$L$23:$S$31';$sheet.PageSetup.Orientation=2
    $sheet.PageSetup.Zoom=$false;$sheet.PageSetup.FitToPagesWide=1;$sheet.PageSetup.FitToPagesTall=1
    $sheet.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.pdf'))
    @{mode=$Mode;header=$table.ListColumns.Item(6).Name;records=$table.ListRows.Count;summaries=$before.summaries}|ConvertTo-Json -Depth 5
} finally {
    if($book){$book.Close($false)}
    $excel.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($excel)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
