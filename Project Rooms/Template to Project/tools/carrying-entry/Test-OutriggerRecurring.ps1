param([Parameter(Mandatory)][string]$Workbook,[switch]$RealDataOnly)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    $b=$e.Workbooks.Open($Workbook,0,$false)
    $s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    $count=$t.ListRows.Count;$baseline=$b.Worksheets.Item('Profit').Range('B43').Value2
    $date=$b.Names.Item('ceDate').RefersToRange
    $vendor=$b.Names.Item('ceVendor').RefersToRange
    Assert ($vendor.Validation.Formula1 -eq '=ceVendorList' -and $vendor.Validation.InCellDropdown) 'Vendor dropdown missing.'
    Assert (-not $vendor.Validation.ShowError) 'New Vendor entry prohibited.'
    Assert ($b.Names.Item('ceVendorList').RefersToRange.Rows.Count -eq 7) 'Outrigger Vendor list changed.'
    $insert=$s.Shapes.Item('ceInsertButton');$recurring=$s.Shapes.Item('ceRecurringButton')
    # Native form-control anchors can move by one screen pixel during save.
    Assert ($insert.Width -eq $recurring.Width -and $insert.Height -eq $recurring.Height -and [math]::Abs($insert.Left-$recurring.Left) -le .75) 'Button dimensions differ.'
    Assert ($recurring.Top -gt $insert.Top+$insert.Height -and $recurring.Top+$recurring.Height -lt $s.Range('A5').Top) 'Button overlaps grid.'
    Assert ($b.Names.Item('ceFeedback').RefersToRange.Left -gt $recurring.Left+$recurring.Width) 'Feedback overlaps button.'
    function Set-Field($name,$value){
        $cell=$b.Names.Item('ce'+$name).RefersToRange
        [void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))
    }
    function Set-Cell($cell,$value){
        [void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))
    }
    function Prefill([int]$row=0){[string]$e.Run("'"+$b.Name.Replace("'","''")+"'!CarryingEntry_Prefill",$row)}
    foreach($entry in @(@('Duke Electric','2027-04-17',$null),@('Water','2027-04-28',$null))){
        Set-Field Vendor $entry[0];$date.MergeArea.ClearContents()
        Assert ((Prefill).StartsWith('Filled.')) 'Descriptions incorrectly split a recurring bill.'
        Assert ($date.Value2 -eq ([datetime]$entry[1]).ToOADate()) 'Combined Vendor/Category history date incorrect.'
        Assert ($null -eq $b.Names.Item('ceAmount').RefersToRange.Value2) 'Blank latest forecast amount not preserved.'
        Assert ($b.Names.Item('ceDescription').RefersToRange.Value2 -eq 'Migrated from original Carrying grid') 'Latest description not selected.'
    }
    Set-Field Vendor 'Unknown Vendor'
    Assert ((Prefill).Contains('no matching')) 'Unknown Vendor accepted.'
    $results=[Collections.Generic.List[object]]::new()
    # A second category still requires a choice; choosing an older row selects the latest in that category.
    $extra=$t.ListRows.Add().Range
    foreach($pair in @(@('Vendor','Water'),@('Category','Labor'),@('Description','TEST alternate category'),@('Include','No'))){$extra.Cells.Item(1,$t.ListColumns.Item($pair[0]).Index).Value2=$pair[1]}
    Set-Cell $extra.Cells.Item(1,$t.ListColumns.Item('Date').Index) (([datetime]'2027-01-01').ToOADate())
    Set-Field Vendor 'Water';$date.MergeArea.ClearContents();Set-Field Description 'Preserve pending input'
    Assert ((Prefill).StartsWith('Choose a category:')) 'Multiple categories silently selected.'
    Assert ($null -eq $date.Value2 -and $b.Names.Item('ceDescription').RefersToRange.Value2 -eq 'Preserve pending input') 'Ambiguous selection changed form.'
    $oldWater=0
    for($i=1;$i -le $count;$i++){if($t.DataBodyRange.Cells.Item($i,$t.ListColumns.Item('Vendor').Index).Value2 -eq 'Water'){$oldWater=$i;break}}
    Assert ((Prefill $oldWater).StartsWith('Filled.') -and $date.Value2 -eq ([datetime]'2027-04-28').ToOADate()) 'Category selection did not use full history.'
    Assert ($b.Names.Item('ceDescription').RefersToRange.Value2 -eq 'Migrated from original Carrying grid') 'Category selection reused older description.'
    Assert ((Prefill ($count+2)).Contains('invalid category record')) 'Out-of-range row accepted.'
    Assert ((Prefill 1).Contains('no matching Vendor')) 'Different vendor row accepted.'
    $t.ListRows.Item($count+1).Delete()
    $results.Add(@{case='Vendor/Category match, latest description, category separation and explicit choice';passed=$true})
    $cases=@(
        @{name='Monthly';dates=@('2026-01-10','2026-02-10','2026-03-10');expected='2026-04-10'},
        @{name='Monthly jitter';dates=@('2026-05-05','2026-06-04','2026-07-07');expected='2026-08-07'},
        @{name='Weekly';dates=@('2026-09-01','2026-09-08','2026-09-15');expected='2026-09-22'},
        @{name='Quarterly';dates=@('2025-10-15','2026-01-15','2026-04-15');expected='2026-07-15'},
        @{name='Annual';dates=@('2023-09-01','2024-09-01','2025-09-01');expected='2026-09-01'},
        @{name='Month end';dates=@('2026-01-31','2026-02-28','2026-03-31');expected='2026-04-30'},
        @{name='February clamp';dates=@('2025-12-30','2026-01-30','2026-02-28');expected='2026-03-30'},
        @{name='Leap month end';dates=@('2023-11-30','2023-12-31','2024-01-31');expected='2024-02-29'},
        @{name='Leap annual';dates=@('2022-02-28','2023-02-28','2024-02-29');expected='2025-02-28'},
        @{name='Irregular';dates=@('2026-01-01','2026-02-15','2026-04-04');expected=$null},
        @{name='Insufficient';dates=@('2026-01-10','2026-02-10');expected=$null},
        @{name='Duplicate day';dates=@('2026-01-10','2026-01-10','2026-02-10');expected=$null},
        @{name='Unsorted and duplicate';dates=@('2026-03-10','2026-01-10','2026-02-10','2026-03-10');expected='2026-04-10'},
        @{name='Missing month';dates=@('2026-01-10','2026-02-10','2026-04-10');expected=$null}
    )
    if($RealDataOnly){$cases=@()}
    foreach($case in $cases){
        foreach($d in $case.dates){
            $r=$t.ListRows.Add().Range
            foreach($pair in @(@('Vendor','TEST recurrence'),@('Category','Labor'),@('Description','TEST bill'),@('Include','No'))){
                $r.Cells.Item(1,$t.ListColumns.Item($pair[0]).Index).Value2=$pair[1]
            }
            Set-Cell $r.Cells.Item(1,$t.ListColumns.Item('Date').Index) (([datetime]$d).ToOADate())
            Set-Cell $r.Cells.Item(1,$t.ListColumns.Item('Amount').Index) 12.34
        }
        Set-Field Vendor 'TEST recurrence';$date.MergeArea.ClearContents()
        $n=$t.ListRows.Count
        [void]$t.Range.AutoFilter($t.ListColumns.Item('Category').Index,'Water')
        $message=Prefill
        Assert ($message.StartsWith('Filled.')) "Prefill failed: $message"
        if($case.expected){Assert ($date.Value2 -eq ([datetime]$case.expected).ToOADate()) "$($case.name): wrong suggested date $($date.Text)"}
        else{Assert ($null -eq $date.Value2) "$($case.name): uncertain date was guessed"}
        Assert ($t.ListRows.Count -eq $n) 'Prefill added an expense.'
        Assert ($b.Worksheets.Item('Profit').Range('B43').Value2 -eq $baseline) 'Prefill changed totals.'
        $results.Add(@{case=$case.name;suggested=$date.Text})
        $t.AutoFilter.ShowAllData()
        $date.Formula2='=DATE(2027,1,2)'
        [void](Prefill)
        Assert ($date.Formula2 -eq '=DATE(2027,1,2)') 'Existing Date formula overwritten.'
        Set-Field Date ([datetime]'2027-02-03').ToOADate();[void](Prefill)
        Assert ($date.Value2 -eq ([datetime]'2027-02-03').ToOADate()) 'Entered Date overwritten.'
        while($t.ListRows.Count -gt $count){$t.ListRows.Item($t.ListRows.Count).Delete()}
    }
    # Real Outrigger histories: clear enough to infer, and a one-off record that must remain blank.
    foreach($case in @(@{vendor='Mortgage Payment';expected='2026-11-02'},@{vendor='Property Taxes';expected='2042-08-28'},@{vendor='Insurance Payments';expected='2027-08-02'})){
        Set-Field Vendor $case.vendor;$date.MergeArea.ClearContents();$message=Prefill
        Assert ($message.StartsWith('Filled.')) "Real vendor failed: $message"
        if($case.expected){Assert ($date.Value2 -eq ([datetime]$case.expected).ToOADate()) "Real vendor date wrong: $($case.vendor)"}
        else{Assert ($null -eq $date.Value2) 'One-off Labor date guessed.'}
        $results.Add(@{case=$case.vendor;suggested=$date.Text})
    }
    Assert ($t.ListRows.Count -eq $count -and $e.Calculation -eq -4105) 'Record count/calculation changed.'
    Assert ($e.EnableEvents -eq $false) 'Events not restored.'
    [ordered]@{passed=$results;records=$count;profit=$baseline;changesSaved=$false}|ConvertTo-Json -Depth 4
}finally{
    if($b){$b.Close($false);[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($b)}
    $e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
