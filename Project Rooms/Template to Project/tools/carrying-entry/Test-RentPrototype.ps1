param([Parameter(Mandatory)][string]$Workbook,[Parameter(Mandatory)][string]$Baseline,[Parameter(Mandatory)][string]$Evidence)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Near($a,$b){[math]::Abs([double]$a-[double]$b) -lt .00001}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
$base=Get-Content -LiteralPath $Baseline -Raw|ConvertFrom-Json
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Workbook,0,$false);$p=$b.Worksheets.Item('Profit');$s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    function Field($name){$b.Names.Item('ce'+$name).RefersToRange}
    function Run($name){$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name)}
    function Recalc{$e.CalculateFullRebuild()}
    function Metric($address){$p.Range($address).Value2}
    function Add-Rent($date,$amount,$status,$id){
        $r=$t.ListRows.Add().Range
        $v=@('Yes','Rent',$date,'TEST Rent','TEST rent', $amount,'TEST',$id,'TEST',$status,'TEST - never saved')
        for($c=1;$c -le 11;$c++){Set-Cell $r.Cells.Item(1,$c) $v[$c-1]}
    }
    $passed=[Collections.Generic.List[string]]::new()
    Assert ($e.Calculation -eq -4105) 'Not automatic on normal reopen.'
    Assert ($null -eq $b.LinkSources(1)) 'External workbook link.'
    $original=$t.DataBodyRange.Formula2
    for($m=0;$m -lt 12;$m++){
        Assert ($s.Cells.Item(10+$m,37).Value2 -eq ([datetime]'2025-07-01').AddMonths($m).ToOADate()) "Rent grid month mismatch $m"
        Assert ($s.Cells.Item(10+$m,38).Value2 -eq 1850 -and $s.Cells.Item(10+$m,37).Text -notmatch '^#+$') "Rent grid amount/display mismatch $m"
    }
    Assert ($s.Range('U6').Validation.Formula1 -match 'Reported Collected') 'Rent status choices missing.'
    foreach($n in 1,2,3){
        Set-Cell $p.Range('E1') $n;Recalc
        Assert (Near (Metric 'B43') 28224.97) "Expenses changed in mode $n"
        Assert (Near (Metric 'E9') 22200) "Rent missing in mode $n"
        $expected=[double]$base.modes."$n".J58
        if($n -eq 1){$expected+=22200}
        Assert (Near (Metric 'J58') $expected) "Double-count or wrong net result in mode $n"
        Assert (Near (Metric 'K9') $base.modes."$n".K9) "Monthly cash flow changed in mode $n"
        Assert (Near (Metric 'H15') $base.modes."$n".H15) "Loan payoff changed in mode $n"
    }
    $passed.Add('All three models: actual rent counted once; Hold replaces the same rent estimate; CFD and loan payoff unchanged')
    Set-Cell $p.Range('E1') 1
    Set-Cell $t.DataBodyRange.Cells.Item(57,10) 'Scheduled';Recalc
    Assert (Near (Metric 'V19') 20350) 'Schedule counted as collected.'
    Assert ((Metric 'V20') -eq 12 -and (Metric 'V22') -eq 1850) 'Scheduled occupancy or amount wrong.'
    Set-Cell $t.DataBodyRange.Cells.Item(57,10) 'Entered';Recalc
    Assert (Near (Metric 'V19') 20350) 'Entered counted as collected.'
    Assert ((Metric 'V20') -eq 11) 'Unclassified entry counted as occupancy.'
    Set-Cell $t.DataBodyRange.Cells.Item(57,10) 'Reported Collected'
    Set-Cell $t.DataBodyRange.Cells.Item(57,1) 'No';Recalc
    Assert (Near (Metric 'V19') 20350) 'Excluded rent counted.'
    Set-Cell $t.DataBodyRange.Cells.Item(57,1) 'Yes'
    Set-Cell $t.DataBodyRange.Cells.Item(57,6) 1000
    Add-Rent ([datetime]'2025-07-01').ToOADate() 850 'Collected' 'TEST-SPLIT';Recalc
    Assert ((Metric 'V20') -eq 12 -and (Metric 'V19') -eq 22200) 'Split payment counted as two rental months.'
    Add-Rent ([datetime]'2025-07-01').ToOADate() -50 'Collected' 'TEST-REFUND';Recalc
    Assert ((Metric 'V20') -eq 12 -and (Metric 'V19') -eq 22150) 'Refund not netted or changed occupancy.'
    $t.ListRows.Item($t.ListRows.Count).Delete();$t.ListRows.Item($t.ListRows.Count).Delete()
    Set-Cell $t.DataBodyRange.Cells.Item(57,6) 1850
    $future=(Get-Date -Day 1).Date.AddMonths(2)
    Add-Rent $future.ToOADate() 1000 'Collected' 'TEST-PREPAID'
    Add-Rent $future.AddMonths(1).ToOADate() 1850 'Scheduled' 'TEST-FUTURE'
    Set-Cell $p.Range('B9') 14;Recalc
    Assert ((Metric 'V20') -eq 12 -and (Metric 'V23') -eq 1 -and (Metric 'V19') -eq 23200) 'Prepaid/future schedule forecast treatment wrong.'
    $t.ListRows.Item($t.ListRows.Count).Delete();$t.ListRows.Item($t.ListRows.Count).Delete();Set-Cell $p.Range('B9') 12
    $passed.Add('Scheduled, Entered, excluded, partial, split, refund and future/prepaid records')
    # Filtered rows remain included in header-based calculations.
    $s.Activate()
    $probe=$b.VBProject.VBComponents.Add(1);$probe.Name='RentFilterTestOnly'
    $probe.CodeModule.AddFromString("Public Sub RentFilterTestOnly_Run()`r`nThisWorkbook.Worksheets(""Carrying"").ListObjects(""tblCarryingExpenses"").Range.AutoFilter Field:=2, Criteria1:=""Labor""`r`nEnd Sub")
    [void](Run 'RentFilterTestOnly_Run')
    Assert ($t.AutoFilter.Filters.Item(2).On) 'Filter did not activate in the test.'
    Recalc;Assert ((Metric 'V19') -eq 22200) 'Filtering changed totals.'
    if($t.AutoFilter.FilterMode){$t.AutoFilter.ShowAllData()}
    $s.Range('AO61:AY72').EntireRow.Hidden=$true;Recalc
    Assert ((Metric 'V19') -eq 22200 -and (Metric 'V20') -eq 12) 'Hidden records changed totals.'
    $s.Range('AO61:AY72').EntireRow.Hidden=$false
    if([bool]$e.Evaluate($b.Names.Item('ceEditActive').RefersTo)) {[void](Run 'CarryingEdit_Cancel')}
    (Field 'Date').MergeArea.ClearContents();$s.Activate();$s.Range('AK10').Select()
    $result=[string](Run 'CarryingEdit_RecurringFromSelection')
    Assert ((Field 'Vendor').Value2 -eq 'Ever Cardoza' -and (Field 'Date').Value2 -eq ([datetime]'2026-07-01').ToOADate()) "Recurrence failed: $result"
    Assert ((Field 'Status').Value2 -eq 'Entered' -and $t.ListRows.Count -eq 68) 'Prefill created collection or inserted a row.'
    $s.Range('AK10').Select();$result=[string](Run 'CarryingEdit_Load');Assert ($result.StartsWith('Editing')) "Edit failed: $result"
    Set-Cell (Field 'Amount') 1851;$result=[string](Run 'CarryingEdit_Save');Recalc
    Assert ($result.StartsWith('Saved changes') -and (Metric 'V19') -eq 22201) "Edit did not flow to Profit: $result"
    Assert (Near (Metric 'B43') 28224.97) 'Rent edit altered expenses.'
    Set-Cell $t.DataBodyRange.Cells.Item(57,6) 1850
    $s.Range('AK10').Select();[void](Run 'CarryingEdit_Load');Set-Cell (Field 'Amount') 9999;[void](Run 'CarryingEdit_Cancel');Recalc
    Assert ((Metric 'V19') -eq 22200) 'Cancel persisted edit.'
    $passed.Add('Filtered records, grid-selected recurring date, Edit/Save/Cancel and expense exclusion')
    foreach($r in 68..57){$t.ListRows.Item($r).Delete()};Recalc
    Assert ((Metric 'V19') -eq 0 -and (Metric 'V20') -eq 0 -and (Metric 'V23') -eq 12) 'No-rent state failed.'
    foreach($field in @('Date','Category','Vendor','Description','Amount','Invoice','Source','SourceFile','Status','Notes')){(Field $field).MergeArea.ClearContents()}
    Set-Cell (Field 'Date') ([datetime]'2025-07-01').ToOADate();Set-Cell (Field 'Category') 'Rent';Set-Cell (Field 'Vendor') 'TEST Rent'
    Set-Cell (Field 'Description') 'TEST monthly rent';Set-Cell (Field 'Amount') 1234;Set-Cell (Field 'Status') 'Collected';Set-Cell (Field 'Include') $true
    [void](Run 'CarryingEdit_InsertGuard');Recalc
    Assert ($t.ListRows.Count -eq 57 -and (Metric 'V19') -eq 1234 -and (Metric 'V20') -eq 1) 'Insert failed to update rent outputs.'
    Assert (Near (Metric 'B43') 28224.97) 'Inserted rent altered expenses.'
    $passed.Add('Empty Rent state and first manual rent insertion recalculate correctly')
    for($r=1;$r -le 56;$r++){for($c=1;$c -le 11;$c++){Assert ($original[$r,$c] -ceq $t.DataBodyRange.Cells.Item($r,$c).Formula2) "Original expense changed: $r,$c"}}
    [ordered]@{passed=$passed;changesSaved=$false;originalExpenseRecords=56;expenseTotal=Metric 'B43'}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $Evidence
    Get-Content -LiteralPath $Evidence
} catch {Write-Output $_.ScriptStackTrace;throw} finally {
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
