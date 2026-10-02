param([Parameter(Mandatory)][string]$Workbook)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Workbook,0,$false);$s=$b.Worksheets.Item('Carrying');$p=$b.Worksheets.Item('Profit');$t=$s.ListObjects.Item('tblCarryingExpenses')
    function Field($name){$b.Names.Item('ce'+$name).RefersToRange}
    function Run($name){$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name)}
    if([bool]$e.Evaluate($b.Names.Item('ceEditActive').RefersTo)){[void](Run 'CarryingEdit_Cancel')}
    $before=$t.DataBodyRange.Formula2;$count=$t.ListRows.Count;$expense=$p.Range('B43').Value2
    $expenseCells=@('B31','E31','H31','K31','N31','Q31','T31','W31','Z31','AC31','AF31','AI31');$totals=@{}
    foreach($a in $expenseCells){$totals[$a]=$s.Range($a).Value2}
    Assert ($s.Range('AK7').Value2 -eq 'Rent' -and $s.Range('AL31').Value2 -eq 0) 'Rent display missing.'
    Assert ($s.Range('Y1').MergeArea.Address() -eq '$Y$1:$AI$2' -and $b.Names.Item('ceButtonContext').RefersToRange.Address() -eq '$Y$1:$AI$2') 'Instruction box/name mismatch.'
    Assert ($p.Range('B43').Formula2 -eq '=+B28*SUM(B31:B42)') 'Expense formula changed.'
    foreach($month in @(1,2,3)){
        Set-Cell (Field 'Date') ([datetime]::new(2027,$month,1).ToOADate());Set-Cell (Field 'Category') 'Rent';Set-Cell (Field 'Vendor') 'RENT QA TENANT'
        Set-Cell (Field 'Description') 'Rent test only';Set-Cell (Field 'Amount') 1250;Set-Cell (Field 'Include') $true
        Set-Cell (Field 'Invoice') "RENT-QA-$month"
        Assert ($s.Range('C4').Validation.Value) 'Rent not accepted by dropdown.'
        [void](Run 'CarryingEdit_InsertGuard');Assert ((Field 'Feedback').Value2.StartsWith('Inserted')) 'Rent insertion rejected.'
    }
    Assert ($t.ListRows.Count -eq $count+3 -and $s.Range('AL31').Value2 -eq 3750) 'Rent records/subtotal mismatch.'
    Assert ($s.Range('AK10').Value2 -eq ([datetime]'2027-01-01').ToOADate() -and $s.Range('AL10').Value2 -eq 1250) 'Rent grid mismatch.'
    $s.Activate();$s.Range('AK10').Select();[void](Run 'CarryingEdit_RecurringGuard')
    Assert ((Field 'Category').Value2 -eq 'Rent' -and (Field 'Vendor').Value2 -eq 'RENT QA TENANT' -and (Field 'Date').Value2 -eq ([datetime]'2027-04-01').ToOADate()) 'Rent recurrence failed.'
    Assert ($s.Range('Y1').Value2.StartsWith('Recurring Bill:')) 'Context did not update formatted merge.'
    $s.Range('AL10').Select();[void](Run 'CarryingEdit_Load');Set-Cell (Field 'Amount') 1260;[void](Run 'CarryingEdit_Save')
    Assert ($s.Range('AL31').Value2 -eq 3760) 'Rent edit failed.'
    Assert ([math]::Abs($p.Range('B43').Value2-$expense) -lt .000001) 'Rent was rolled into expense total.'
    foreach($a in $expenseCells){Assert ($s.Range($a).Value2 -eq $totals[$a]) "Rent changed expense category $a"}
    $after=$t.DataBodyRange.Formula2
    for($r=1;$r -le $count;$r++){for($c=1;$c -le 11;$c++){Assert ($before[$r,$c] -ceq $after[$r,$c]) "Existing record changed $r,$c"}}
    Assert ($e.Calculation -eq -4105 -and -not $e.EnableEvents) 'Calculation/events changed.'
    [ordered]@{passed='Rent dropdown, insertion, date/amount display, recurring selection and next date, editing, formatted context, exclusion from every expense subtotal and Profit Carrying Cost';originalRecords=$count;expenseTotal=$expense;testRentTotal=3760;changesSaved=$false}|ConvertTo-Json
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
