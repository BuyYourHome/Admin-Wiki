param([Parameter(Mandatory)][string]$Workbook,[string]$PreviewPdf)
$ErrorActionPreference='Stop'
function Assert($ok,[string]$message){if(-not $ok){throw $message}}
$excel=New-Object -ComObject Excel.Application
$excel.Visible=$false
$excel.DisplayAlerts=$false
$excel.EnableEvents=$false
# Only the reviewed workbook is opened; existing event handlers remain disabled.
$excel.AutomationSecurity=1
try {
    $book=$excel.Workbooks.Open($Workbook,0,$false)
    Assert (-not $book.ReadOnly) 'Test copy must be writable (changes are never saved).'
    Assert ($excel.Calculation -eq -4105) 'Saved calculation mode is not Automatic.'
    $sheet=$book.Worksheets.Item('Carrying')
    $table=$sheet.ListObjects.Item('tblCarryingExpenses')
    $profit=$book.Worksheets.Item('Profit')
    $count=$table.ListRows.Count
    $sheet.Shapes.Item('ceIncludeCheckbox').ControlFormat.Value=-4146
    Assert ($book.Names.Item('ceInclude').RefersToRange.Value2 -eq $false) 'Unchecked control not linked.'
    $sheet.Shapes.Item('ceIncludeCheckbox').ControlFormat.Value=1
    Assert ($book.Names.Item('ceInclude').RefersToRange.Value2 -eq $true) 'Checked control not linked.'
    $base=[double]$sheet.Range('AI29').Value2
    $profitBase=[double]$profit.Range('B43').Value2
    function Set-Field([string]$name,$value){
        $cell=$book.Names.Item('ce'+$name).RefersToRange
        [void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))
    }
    function Fill-Record([double]$amount,[string]$invoice,[bool]$include=$true){
        Set-Field Date ([datetime]'2026-09-30').ToOADate()
        Set-Field Category 'Labor'
        Set-Field Vendor '=TEST vendor'
        Set-Field Description '=TEST manual-entry validation'
        Set-Field Amount $amount
        Set-Field Invoice $invoice
        Set-Field Include $include
        Set-Field Source 'Manual Entry'
        Set-Field SourceFile 'TEST ONLY - not an actual invoice'
        Set-Field Status 'Entered'
        Set-Field Notes 'Disposable unsaved test'
    }
    function Submit { [string]$excel.Run("'"+$book.Name.Replace("'","''")+"'!CarryingEntry_Submit") }
    $results=[Collections.Generic.List[string]]::new()
    $r=Submit
    Assert ($r.StartsWith('Not inserted: enter a valid Date.') -and $table.ListRows.Count -eq $count) "Blank validation failed: $r"
    $results.Add('Blank input rejected')
    Fill-Record 12.34 '00001'
    $r=Submit
    Assert ($r.StartsWith('Inserted Labor:') -and $table.ListRows.Count -eq $count+1) "Valid insert failed: $r"
    Assert ([math]::Abs([double]$sheet.Range('AI29').Value2-$base-12.34) -lt .001) 'Labor did not update automatically.'
    Assert ([math]::Abs([double]$profit.Range('B43').Value2-$profitBase-12.34) -lt .001) 'Profit did not update automatically.'
    $last=$table.ListRows.Item($count+1).Range
    Assert ($last.Cells.Item(1,$table.ListColumns.Item('Invoice #').Index).Value2 -ceq '00001') 'Invoice leading zeros lost.'
    Assert (-not $last.Cells.Item(1,$table.ListColumns.Item('Vendor').Index).HasFormula) 'Text was interpreted as formula.'
    Assert ($sheet.Range('AH9').Text -eq '9/30/2026') 'Inserted date not displayed.'
    $results.Add('Valid row, leading zeros, literal text, dates, Labor and Profit automatic recalculation passed')
    $r=Submit
    Assert ($r.StartsWith('Not inserted:') -and $table.ListRows.Count -eq $count+1) 'Second click created a duplicate.'
    Fill-Record 12.34 '00001'
    [void]$table.Range.AutoFilter($table.ListColumns.Item('Category').Index,'Duke Electric')
    Assert ($table.ListRows.Item($count+1).Range.EntireRow.Hidden) 'Duplicate test row is not filtered out.'
    $r=Submit
    Assert ($r.Contains('possible duplicate') -and $table.ListRows.Count -eq $count+1) "Duplicate detection failed: $r"
    if($table.AutoFilter.FilterMode){$table.AutoFilter.ShowAllData()}
    Assert ($book.Names.Item('ceVendor').RefersToRange.Value2 -ceq '=TEST vendor') 'Rejected entry was cleared.'
    $results.Add('Second click and duplicate rejected; rejected input preserved')
    Fill-Record -2.34 '00002'
    $r=Submit
    Assert ($r.StartsWith('Inserted Labor:') -and $table.ListRows.Count -eq $count+2) "Credit failed: $r"
    Assert ([math]::Abs([double]$profit.Range('B43').Value2-$profitBase-10) -lt .001) 'Credit total wrong.'
    Fill-Record 99 '00003' $false
    $r=Submit
    Assert ($r.StartsWith('Inserted Labor:') -and $table.ListRows.Count -eq $count+3) "Excluded record failed: $r"
    Assert ([math]::Abs([double]$profit.Range('B43').Value2-$profitBase-10) -lt .001) 'Excluded record changed total.'
    $results.Add('Negative credit and Include No passed')
    Fill-Record 99 '00003' $true
    $r=Submit
    Assert ($r.Contains('possible duplicate') -and $table.ListRows.Count -eq $count+3) 'Excluded duplicate not detected.'
    Fill-Record 15 '00004'
    Set-Field Category 'Unknown category'
    $r=Submit
    Assert ($r.Contains('select a Category') -and $table.ListRows.Count -eq $count+3) 'Category bypass allowed.'
    $results.Add('Excluded duplicate and pasted invalid category rejected')
    Assert ($excel.EnableEvents -eq $false) 'Event state not restored.'
    if($PreviewPdf){
        # Restore only the test additions and form fields for a representative preview, without saving.
        while($table.ListRows.Count -gt $count){$table.ListRows.Item($table.ListRows.Count).Delete()}
        foreach($n in @('Date','Category','Vendor','Description','Amount','Invoice','SourceFile','Notes','Feedback')){
            $book.Names.Item('ce'+$n).RefersToRange.MergeArea.ClearContents()
        }
        Set-Field Include $true
        Set-Field Source 'Manual Entry'
        Set-Field Status 'Entered'
        $sheet.PageSetup.PrintArea='$A$1:$AJ$29'
        $sheet.PageSetup.Orientation=2
        $sheet.PageSetup.Zoom=$false
        $sheet.PageSetup.FitToPagesWide=1
        $sheet.PageSetup.FitToPagesTall=1
        $sheet.ExportAsFixedFormat(0,$PreviewPdf)
    }
    [ordered]@{passed=$results;baselineRecords=$count;baselineLabor=$base;baselineProfit=$profitBase;button=$sheet.Shapes.Item('ceInsertButton').OnAction;changesSaved=$false} | ConvertTo-Json -Depth 4
}finally{
    if($book){$book.Close($false);[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($book)}
    $excel.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($excel)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
