param(
    [Parameter(Mandatory)][string]$Source,
    [Parameter(Mandatory)][string]$Output,
    [Parameter(Mandatory)][string]$GridRange,
    [Parameter(Mandatory)][string]$Categories,
    [Parameter(Mandatory)][int]$DisplayCapacity
)
$ErrorActionPreference='Stop'
if (Test-Path -LiteralPath $Output) { throw 'Output already exists; do not overwrite a prior build.' }
if ($Categories.Length -gt 255) { throw 'Category list exceeds Excel inline validation limit.' }
$parent=Split-Path -Parent $Output
[void](New-Item -ItemType Directory -Path $parent -Force)
Copy-Item -LiteralPath $Source -Destination $Output
$excel=New-Object -ComObject Excel.Application
$excel.Visible=$false
$excel.DisplayAlerts=$false
$excel.EnableEvents=$false
$excel.AutomationSecurity=3
try {
    $book=$excel.Workbooks.Open($Output,0,$false)
    if($book.ReadOnly -or $book.FileFormat -ne 52){throw 'Expected writable XLSM.'}
    $excel.Calculation=-4135
    $sheet=$book.Worksheets.Item('Carrying')
    $table=$sheet.ListObjects.Item('tblCarryingExpenses')
    $beforeData=$table.Range.Formula2
    $beforeTable=$table.Range.Address()
    if(@($book.Names | Where-Object {$_.Name -eq 'ceVersion'}).Count){throw 'Entry form already installed; do not move the grid twice.'}
    $project=$book.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$book,$null)
    if($project.Protection -ne 0){throw 'VBA project is protected.'}
    $modules=@{}
    foreach($c in $project.VBComponents){
        if($c.Name -eq 'BYHCarryingEntry'){throw 'Module name collision.'}
        $modules[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}
    }
    $grid=$sheet.Range($GridRange)
    if($grid.Row -ne 1 -or $grid.Column -ne 1 -or $grid.Columns.Count -ne 36){throw 'This installer requires independently mapped A1:AJ<end> grid.'}
    if($table.Range.Column -le 36){throw 'Source table overlaps display grid.'}
    $end=$grid.Rows.Count
    if($excel.WorksheetFunction.CountA($sheet.Range("A$($end+1):AJ$($end+4)")) -ne 0){throw 'Destination below grid is not empty.'}
    $heights=@(1..$end | ForEach-Object {$sheet.Rows.Item($_).RowHeight})
    # Move the complete block below itself, then to its final location. Include
    # the blank tail referenced by legacy formulas, so references move together.
    $lastUsed=$sheet.UsedRange.Row+$sheet.UsedRange.Rows.Count-1
    if($lastUsed -gt $end -and $excel.WorksheetFunction.CountA($sheet.Range("A$($end+1):AJ$lastUsed")) -ne 0){throw 'Additional content below grid requires independent mapping.'}
    $moveEnd=$end+4
    if($excel.WorksheetFunction.CountA($sheet.Range("A1000:AJ$(999+$moveEnd)")) -ne 0){throw 'Temporary move area is not empty.'}
    [void]$sheet.Range("A1:AJ$moveEnd").Cut($sheet.Range('A1000'))
    [void]$sheet.Range("A1000:AJ$(999+$moveEnd)").Cut($sheet.Range('A5'))
    for($r=1;$r -le $end;$r++){$sheet.Rows.Item($r+4).RowHeight=$heights[$r-1]}
    $sheet.Range('A1:AJ4').Clear()
    $sheet.Range('A1:AJ4').Font.Name='Calibri'
    $sheet.Range('A1:AJ4').Font.Size=11
    $sheet.Range('A1:AJ4').VerticalAlignment=-4108
    $sheet.Rows.Item(1).RowHeight=19
    $sheet.Rows.Item(2).RowHeight=25
    $sheet.Rows.Item(3).RowHeight=19
    $sheet.Rows.Item(4).RowHeight=25
    $fields=@(
        @('Date','A1:B1','A2:B2','Date','m/d/yyyy'),
        @('Category','C1:F1','C2:F2','Category','@'),
        @('Vendor','G1:K1','G2:K2','Vendor','@'),
        @('Description','L1:Q1','L2:Q2','Description','@'),
        @('Amount','R1:T1','R2:T2','Amount','#,##0.00;[Red](#,##0.00)'),
        @('Include','U1:V1','U2:V2','Include',';;;'),
        @('Invoice #','A3:C3','A4:C4','Invoice','@'),
        @('Source','D3:H3','D4:H4','Source','@'),
        @('Source File','I3:N3','I4:N4','SourceFile','@'),
        @('Notes','O3:T3','O4:T4','Notes','@'),
        @('Status','U3:V3','U4:V4','Status','@')
    )
    foreach($f in $fields){
        $label=$sheet.Range($f[1]);$label.Merge();$label.Cells.Item(1,1).Value2=$f[0];$label.Font.Bold=$true
        $input=$sheet.Range($f[2]);$input.Merge();$input.NumberFormat=$f[4];$input.Interior.Color=65535
        $input.Borders.LineStyle=1;$input.Borders.Color=13882323
        [void]$book.Names.Add('ce'+$f[3],"='Carrying'!"+$input.Cells.Item(1,1).Address())
    }
    $sheet.Range('C2').Validation.Add(3,1,1,$Categories)
    $sheet.Range('C2').Validation.InCellDropdown=$true
    $sheet.Range('C2').Validation.ErrorTitle='Choose a carrying category'
    $sheet.Range('C2').Validation.ErrorMessage='Select a category from the dropdown.'
    $sheet.Range('C2').Validation.ShowError=$true
    $sheet.Range('D4').Value2='Manual Entry'
    $sheet.Range('U4').Value2='Entered'
    $sheet.Range('U2').Value2=$true
    $area=$sheet.Range('U2:V2')
    $check=$sheet.Shapes.AddFormControl(1,$area.Left+5,$area.Top+3,18,18)
    $check.Name='ceIncludeCheckbox';$check.ControlFormat.LinkedCell="'Carrying'!`$U`$2";$check.ControlFormat.Value=1
    $check.TextFrame.Characters().Text='';$check.Placement=1
    $area=$sheet.Range('W1:AA2')
    $button=$sheet.Shapes.AddFormControl(0,$area.Left+3,$area.Top+3,$area.Width-6,$area.Height-6)
    $button.Name='ceInsertButton';$button.TextFrame.Characters().Text='Insert Record';$button.Placement=1
    $button.Visible=-1
    $button.DrawingObject.PrintObject=$true
    $button.OnAction="'"+$book.Name.Replace("'","''")+"'!CarryingEntry_Insert"
    $feedback=$sheet.Range('W3:AJ4');$feedback.Merge();$feedback.WrapText=$true
    $feedback.Interior.Color=49407
    [void]$book.Names.Add('ceFeedback',"='Carrying'!`$W`$3")
    [void]$book.Names.Add('ceCategories','="'+$Categories+'"')
    [void]$book.Names.Add('ceDisplayCapacity','='+$DisplayCapacity)
    [void]$book.Names.Add('ceVersion','="1.0"')
    [void]$project.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingEntry.bas'))
    foreach($c in $project.VBComponents){
        if($c.Name -eq 'BYHCarryingEntry'){continue}
        $code=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}
        if($modules[$c.Name] -cne $code){
            [ordered]@{module=$c.Name;before=$modules[$c.Name];after=$code} | ConvertTo-Json
            throw "Existing VBA changed: $($c.Name)"
        }
    }
    if($table.Range.Address() -ne $beforeTable){throw 'Source table moved.'}
    $afterData=$table.Range.Formula2
    for($r=1;$r -le $beforeData.GetLength(0);$r++){
        for($c=1;$c -le $beforeData.GetLength(1);$c++){
            if($beforeData[$r,$c] -cne $afterData[$r,$c]){throw "Source data changed: $r,$c"}
        }
    }
    $excel.Calculation=-4105
    $excel.CalculateFullRebuild()
    $book.Save()
    [ordered]@{output=$Output;records=$table.ListRows.Count;table=$table.Range.Address();profitCarrying=$book.Worksheets.Item('Profit').Range('B43').Value2;labor=$sheet.Range('AI29').Value2;button=$button.OnAction;calculation=$excel.Calculation} | ConvertTo-Json
} finally {
    if($book){$book.Close($false);[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($book)}
    $excel.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($excel)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
