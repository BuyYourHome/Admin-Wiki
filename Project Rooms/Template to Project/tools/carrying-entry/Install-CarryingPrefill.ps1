param(
    [Parameter(Mandatory)][string]$Source,
    [Parameter(Mandatory)][string]$Output,
    [Parameter(Mandatory)][string]$ExpectedTableAddress,
    [Parameter(Mandatory)][int]$ExpectedBlankVendors,
    [switch]$FillBlankVendorsFromCategory
)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
Assert (-not (Test-Path -LiteralPath $Output)) 'Output already exists.'
[void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try {
    $b=$e.Workbooks.Open($Output,0,$false)
    Assert (-not $b.ReadOnly -and $b.FileFormat -eq 52) 'Expected writable XLSM.'
    Assert (-not $b.Date1904) 'Date inference requires the mapped 1900 date system.'
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    Assert ($v.Protection -eq 0) 'VBA project protected.'
    $code=@{};foreach($c in $v.VBComponents){$code[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
    Assert (-not $code.ContainsKey('BYHCarryingPrefill')) 'Prefill module already exists.'
    $s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    Assert ($t.Range.Address() -eq $ExpectedTableAddress) 'Source table map changed.'
    Assert ($e.WorksheetFunction.CountA($s.Columns.Item('AX')) -eq 0) 'Helper column occupied.'
    $before=$t.DataBodyRange.Formula2;$filled=0
    $vc=$t.ListColumns.Item('Vendor').Index;$cc=$t.ListColumns.Item('Category').Index
    $blankCount=0
    for($r=1;$r -le $t.ListRows.Count;$r++){
        $cell=$t.DataBodyRange.Cells.Item($r,$vc)
        if(-not $cell.HasFormula -and [string]::IsNullOrWhiteSpace([string]$cell.Value2)){
            $blankCount++
            if(-not $FillBlankVendorsFromCategory){continue}
            $value=[string]$t.DataBodyRange.Cells.Item($r,$cc).Value2
            Assert (-not [string]::IsNullOrWhiteSpace($value)) "Missing Category in row $r"
            $cell.Value2=$value;$before[$r,$vc]=$value;$filled++
        }
    }
    Assert ($blankCount -eq $ExpectedBlankVendors) 'Blank Vendor map changed.'
    $s.Range('AX1').Value2='Vendor list'
    $s.Range('AX2').Formula2='=LET(v,TRIM(tblCarryingExpenses[Vendor]&""),SORT(UNIQUE(FILTER(v,v<>"",""))))'
    [void]$b.Names.Add('ceVendorList',"=Carrying!`$AX`$2#")
    $s.Columns.Item('AX').Hidden=$true
    $input=$b.Names.Item('ceVendor').RefersToRange.MergeArea
    $input.Validation.Delete();$input.Validation.Add(3,1,1,'=ceVendorList')
    $input.Validation.InCellDropdown=$true;$input.Validation.ShowError=$false
    $old=$s.Shapes.Item('ceInsertButton')
    $top=$old.Top+$old.Height+4
    Assert ($top+$old.Height -le $s.Range('A5').Top) 'New button would overlap grid.'
    $button=$s.Shapes.AddFormControl(0,$old.Left,$top,$old.Width,$old.Height)
    $button.Name='ceRecurringButton';$button.Placement=$old.Placement;$button.Visible=-1
    $button.DrawingObject.PrintObject=$true;$button.TextFrame.Characters().Text='Recurring Bill'
    $button.OnAction="'"+$b.Name.Replace("'","''")+"'!CarryingEntry_Recurring"
    # Feedback was below Insert Record. Move its output right, away from both buttons.
    Assert ($b.Names.Item('ceFeedback').RefersToRange.Address() -eq '$W$3') 'Feedback map changed.'
    Assert ([string]::IsNullOrEmpty([string]$s.Range('Z3').Value2)) 'Feedback destination occupied.'
    $s.Range('Z3').Formula2=$s.Range('W3').Formula2
    $s.Range('W3').ClearContents()
    [void]$b.Names.Add('ceFeedback',"=Carrying!`$Z`$3")
    [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingPrefill.bas'))
    foreach($c in $v.VBComponents){if($code.ContainsKey($c.Name)){
        $now=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}
        Assert ($code[$c.Name] -ceq $now) "Existing macro changed: $($c.Name)"
    }}
    $after=$t.DataBodyRange.Formula2
    for($r=1;$r -le $before.GetLength(0);$r++){for($c=1;$c -le $before.GetLength(1);$c++){
        Assert ($before[$r,$c] -ceq $after[$r,$c]) "Unexpected record change: $r,$c"
    }}
    Assert ($null -eq $b.LinkSources(1)) 'Unexpected external link.'
    $e.Calculation=-4105;$e.CalculateFullRebuild();$b.Save()
    [ordered]@{vendorsFilled=$filled;records=$t.ListRows.Count;vendorList=$b.Names.Item('ceVendorList').RefersToRange.Value2;profit=$b.Worksheets.Item('Profit').Range('B43').Value2;button=$button.OnAction;buttonWidth=$button.Width;buttonHeight=$button.Height} | ConvertTo-Json -Depth 3
}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
