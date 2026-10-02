param([Parameter(Mandatory)][string]$Workbook,[Parameter(Mandatory)][string]$Evidence)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Workbook,0,$false);$s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    $count=$t.ListRows.Count;$original=$t.DataBodyRange.Formula2;$baseline=[double]$b.Worksheets.Item('Profit').Range('B43').Value2
    $grid=$b.Names.Item('ceEditGrid').RefersToRange;$footer=$grid.Row+$grid.Rows.Count
    function Field($name){$b.Names.Item('ce'+$name).RefersToRange}
    function Run($name){$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name)}
    function Context($label){Assert (([string]$b.Names.Item('ceButtonContext').RefersToRange.Cells.Item(1,1).Value2).StartsWith($label+':')) "Context not updated for $label"}
    function Near($a,$b){[math]::Abs([double]$a-[double]$b) -lt .000001}
    $passed=[Collections.Generic.List[string]]::new()
    Assert ($e.Calculation -eq -4105) 'Calculation must reopen as Automatic.'
    Assert ($s.Range('Y1').MergeArea.Address() -eq '$Y$1:$AI$2') 'Instruction merge mismatch.'
    Assert ($s.Range('J7').Text -eq 'Refinance' -and $s.Range('AK7').Text -eq 'Rent') 'Category headings mismatch.'
    Assert ($null -eq $b.LinkSources(1)) 'External workbook links.'
    foreach($shapeName in @('ceRecurringButton','ceInsertButton','ceEditButton','ceSaveButton','ceCancelButton')){
        $shape=$s.Shapes.Item($shapeName)
        Assert ($shape.Visible -eq -1 -and $shape.Top+$shape.Height -le $s.Range('A3').Top -and $shape.Left+$shape.Width -lt $s.Range('Y1').Left) "Button misplaced: $shapeName"
        Assert (([string]$shape.OnAction).StartsWith("'"+$b.Name+"'!CarryingEdit_")) "Wrong button macro: $shapeName"
    }
    if([bool]$e.Evaluate($b.Names.Item('ceEditActive').RefersTo)){[void](Run 'CarryingEdit_Cancel')}
    $passed.Add('Native reopen, automatic calculation, names, controls and instruction layout')
    $headings=$b.Names.Item('ceEditHeaders').RefersToRange
    for($col=1;$col -le $headings.Columns.Count;$col+=3){
        $category=[string]$headings.Cells.Item(1,$col).Value2
        if($category -eq 'Mortgage Payment paid after Reinstatement'){$category='Mortgage Payment'}
        $matching=@(for($r=1;$r -le $count;$r++){
            if($original[$r,1] -eq 'Yes' -and $original[$r,2] -eq $category){
                [pscustomobject]@{row=$r;date=$t.DataBodyRange.Cells.Item($r,3).Value2;amount=$t.DataBodyRange.Cells.Item($r,6).Value2}
            }
        }) | Sort-Object date,row
        Assert (@($matching).Count -le $grid.Rows.Count) "Grid overflow: $category"
        for($i=0;$i -lt @($matching).Count;$i++){
            $date=$grid.Cells.Item($i+1,$col);$amount=$grid.Cells.Item($i+1,$col+1);$record=@($matching)[$i]
            Assert (Near $date.Value2 $record.date) "Grid date mismatch $category row $i"
            if($record.date){Assert ($date.Text -and $date.Text -notmatch '^#+$') "Invisible date $category row $i"}
            if($record.amount -is [double]){Assert (Near $amount.Value2 $record.amount) "Grid amount mismatch $category row $i"}
            else{Assert ($null -eq $record.amount -or ([string]$record.amount).Trim() -eq '') "Unmapped amount $category row $i"}
        }
    }
    $passed.Add('Every included record appears with its own paired date and amount; no grid overflow')
    # All synthetic records and edits are discarded when this test session closes.
    foreach($day in @('2025-01-31','2025-02-28','2025-03-31')){
        $row=$t.ListRows.Add().Range
        $values=@('Yes','Rent',([datetime]$day).ToOADate(),'TEST Full Carrying','TEST recurring rent',1250,'Manual Entry',('TEST-'+$day),'TEST only','Entered','')
        for($col=1;$col -le 11;$col++){Set-Cell $row.Cells.Item(1,$col) $values[$col-1]}
        $row.Cells.Item(1,3).NumberFormat='m/d/yyyy'
    }
    $e.CalculateFullRebuild()
    Assert (Near $s.Cells.Item($footer,38).Value2 3750) 'Rent subtotal failed.'
    Assert (Near $b.Worksheets.Item('Profit').Range('B43').Value2 $baseline) 'Rent entered expense total.'
    (Field 'Date').MergeArea.ClearContents();Set-Cell (Field 'Vendor') 'Wrong previous vendor'
    $s.Activate();$s.Range('AK10').Select()
    $result=[string](Run 'CarryingEdit_RecurringFromSelection');Context 'Recurring Bill'
    Assert ((Field 'Vendor').Value2 -eq 'TEST Full Carrying' -and (Field 'Category').Value2 -eq 'Rent') "Selected-grid recurring failed: $result"
    Assert ((Field 'Date').Value2 -eq ([datetime]'2025-04-30').ToOADate()) "Next logical date failed: $result"
    Assert ($t.ListRows.Count -eq $count+3) 'Recurring inserted unexpectedly.'
    $passed.Add('Grid-selected vendor/category and next-month-end date; Rent excluded from expense total')
    $s.Range('AL10').Select();$result=[string](Run 'CarryingEdit_Load');Context 'Edit Record'
    Assert ($result.StartsWith('Editing')) "Grid edit failed: $result"
    Set-Cell (Field 'Amount') 1260
    [void](Run 'CarryingEdit_InsertGuard');Context 'Insert Record'
    Assert ($t.ListRows.Count -eq $count+3) 'Active-edit insert guard failed.'
    [void](Run 'CarryingEdit_RecurringGuard');Context 'Recurring Bill'
    Assert ((Field 'Amount').Value2 -eq 1260) 'Recurring changed an active edit.'
    $result=[string](Run 'CarryingEdit_Save');Context 'Save Changes'
    Assert ($result.StartsWith('Saved changes') -and $t.DataBodyRange.Cells.Item($count+1,6).Value2 -eq 1260) "Save wrong record: $result"
    Assert (Near $s.Cells.Item($footer,38).Value2 3760) 'Edited Rent subtotal failed.'
    Assert (Near $b.Worksheets.Item('Profit').Range('B43').Value2 $baseline) 'Edited Rent entered expenses.'
    $s.Range('AK10').Select();[void](Run 'CarryingEdit_Load');Set-Cell (Field 'Amount') 9999
    [void](Run 'CarryingEdit_Cancel');Context 'Cancel Edit'
    Assert ($t.DataBodyRange.Cells.Item($count+1,6).Value2 -eq 1260) 'Cancel changed record.'
    $passed.Add('Edit/save/cancel, unchanged-record preservation, all button instructions and edit guards')
    foreach($cat in @('Labor','Refinance')){
        Set-Cell (Field 'Date') ([datetime]'2026-10-02').ToOADate();Set-Cell (Field 'Category') $cat
        Set-Cell (Field 'Vendor') 'TEST Full Carrying';Set-Cell (Field 'Description') ('TEST '+$cat)
        Set-Cell (Field 'Amount') 2.5;Set-Cell (Field 'Include') $true
        Set-Cell (Field 'Invoice') ('TEST-'+$cat);Set-Cell (Field 'Source') 'Manual Entry'
        Set-Cell (Field 'SourceFile') 'TEST';Set-Cell (Field 'Status') 'Entered';Set-Cell (Field 'Notes') 'TEST'
        [void](Run 'CarryingEdit_InsertGuard')
    }
    Assert ($t.ListRows.Count -eq $count+5) "Insert failed: $((Field 'Feedback').Value2)"
    Assert (Near $b.Worksheets.Item('Profit').Range('B43').Value2 ($baseline+5)) 'Labor/Refinance not flowing to Profit.'
    [void](Run 'CarryingEdit_InsertGuard');Assert ($t.ListRows.Count -eq $count+5) 'Empty/duplicate form inserted.'
    $passed.Add('Labor and Refinance insertion flow to Profit without Rent; no unintended insertion')
    $after=$t.DataBodyRange.Formula2
    for($r=1;$r -le $count;$r++){for($c=1;$c -le 11;$c++){Assert ($original[$r,$c] -ceq $after[$r,$c]) "Existing record modified $r,$c"}}
    Assert ($e.EnableEvents -eq $false) 'Events unexpectedly enabled.'
    $result=[ordered]@{file=$b.Name;passed=$passed;baselineRecords=$count;baselineProfit=$baseline;changesSaved=$false}
    $result|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $Evidence
    $result|ConvertTo-Json -Depth 5
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
