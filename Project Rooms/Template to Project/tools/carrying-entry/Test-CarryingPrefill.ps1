param([Parameter(Mandatory)][string]$Workbook)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
$excel=New-Object -ComObject Excel.Application
$excel.Visible=$false
$excel.DisplayAlerts=$false
$excel.EnableEvents=$false
$excel.AutomationSecurity=1
try {
    $book=$excel.Workbooks.Open($Workbook,0,$false)
    $sheet=$book.Worksheets.Item('Carrying')
    $table=$sheet.ListObjects.Item('tblCarryingExpenses')
    $count=$table.ListRows.Count
    $profit=$book.Worksheets.Item('Profit').Range('B43').Value2
    function Set-Field($name,$value){
        $cell=$book.Names.Item('ce'+$name).RefersToRange
        [void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))
    }
    function Get-Field($name){$book.Names.Item('ce'+$name).RefersToRange.Value2}
    function Prefill([int]$row=0){[string]$excel.Run("'"+$book.Name.Replace("'","''")+"'!CarryingEntry_Prefill",$row)}
    $vendor=$book.Names.Item('ceVendor').RefersToRange
    Assert ($vendor.Validation.Formula1 -eq '=ceVendorList' -and $vendor.Validation.InCellDropdown) 'Vendor dropdown missing.'
    Assert (-not $vendor.Validation.ShowError) 'New vendor entry prohibited.'
    Assert ($book.Names.Item('ceVendorList').RefersToRange.Rows.Count -eq 6) 'Expected six unique vendors.'
    $insert=$sheet.Shapes.Item('ceInsertButton');$recurring=$sheet.Shapes.Item('ceRecurringButton')
    Assert ($insert.Width -eq $recurring.Width -and $insert.Height -eq $recurring.Height -and $insert.Left -eq $recurring.Left) 'Button dimensions differ.'
    Assert ($recurring.Top -gt $insert.Top+$insert.Height -and $recurring.Top+$recurring.Height -lt $sheet.Range('A5').Top) 'Button overlaps form/grid.'
    Assert ($book.Names.Item('ceFeedback').RefersToRange.Left -gt $recurring.Left+$recurring.Width) 'Feedback overlaps button.'
    Assert ((Prefill).StartsWith('Not filled: select')) 'Blank vendor accepted.'
    Set-Field Vendor 'UNKNOWN';Set-Field Description 'Preserve this'
    Assert ((Prefill).Contains('no matching') -and (Get-Field Description) -eq 'Preserve this') 'Unknown vendor changed form.'
    Set-Field Vendor 'Mortgage Payment';Set-Field Date ([datetime]'2026-10-15').ToOADate()
    Set-Field Invoice 'Old invoice';Set-Field SourceFile 'Old file';Set-Field Notes 'Old notes'
    Assert ((Prefill).StartsWith('Filled')) 'Mortgage prefill failed.'
    Assert ((Get-Field Category) -eq 'Mortgage Payment' -and [math]::Abs((Get-Field Amount)-660.59) -lt .001) 'Latest mortgage amount incorrect.'
    Assert ((Get-Field Date) -eq ([datetime]'2026-10-15').ToOADate()) 'Entered date changed.'
    foreach($name in @('Invoice','SourceFile','Notes')){Assert ($null -eq (Get-Field $name)) "Old $name reused."}
    Assert ((Get-Field Source) -eq 'Manual Entry' -and (Get-Field Status) -eq 'Entered') 'Manual defaults missing.'
    Set-Field Vendor 'Duke Electric'
    [void]$table.Range.AutoFilter($table.ListColumns.Item('Category').Index,'Mortgage Payment')
    Assert ((Prefill).StartsWith('Filled') -and $null -eq (Get-Field Amount)) 'Filtered vendor or blank amount failed.'
    $table.AutoFilter.ShowAllData()
    Assert ($table.ListRows.Count -eq $count -and $book.Worksheets.Item('Profit').Range('B43').Value2 -eq $profit) 'Prefill inserted/changed an expense.'
    $new=$table.ListRows.Add().Range
    $new.Cells.Item(1,$table.ListColumns.Item('Vendor').Index).Value2='Duke Electric'
    $new.Cells.Item(1,$table.ListColumns.Item('Category').Index).Value2='Labor'
    $new.Cells.Item(1,$table.ListColumns.Item('Description').Index).Value2='Different bill'
    $new.Cells.Item(1,$table.ListColumns.Item('Amount').Index).Value2=-12.5
    $new.Cells.Item(1,$table.ListColumns.Item('Include').Index).Value2='No'
    Set-Field Description 'Do not replace'
    Assert ((Prefill).StartsWith('Choose a ') -and (Get-Field Description) -eq 'Do not replace') 'Ambiguous bills silently selected.'
    Assert ((Prefill ($count+1)).StartsWith('Filled') -and (Get-Field Amount) -eq -12.5 -and (Get-Field Include) -eq $false) 'Explicit row/credit/exclusion failed.'
    $new.Cells.Item(1,$table.ListColumns.Item('Vendor').Index).Value2='NEW vendor'
    $excel.Calculate()
    Assert ($book.Names.Item('ceVendorList').RefersToRange.Rows.Count -eq 7) 'Vendor list did not expand.'
    $table.ListRows.Item($count+1).Delete()
    $excel.Calculate()
    Assert ($book.Names.Item('ceVendorList').RefersToRange.Rows.Count -eq 6) 'Vendor list did not shrink.'
    Assert ($excel.EnableEvents -eq $false) 'Events not restored.'
    [ordered]@{passed=$true;records=$count;profit=$profit;checks='dropdown; button geometry; blank/unknown; latest; date preservation; provenance cleared; filtered rows; blank amount; ambiguity; explicit row; credit; Include No; dynamic list';changesSaved=$false}|ConvertTo-Json
}finally{
    if($book){$book.Close($false);[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($book)}
    $excel.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($excel)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
