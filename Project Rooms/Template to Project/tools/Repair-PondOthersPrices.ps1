param(
    [Parameter(Mandatory)][ValidateSet('Build','Verify')][string]$Mode,
    [Parameter(Mandatory)][string]$File,
    [Parameter(Mandatory)][string]$Map,
    [Parameter(Mandatory)][string]$Evidence,
    [string]$Output
)
$ErrorActionPreference='Stop'
function Assert($Test,[string]$Message) { if(-not $Test){throw $Message} }
function Metadata($Book) {
    $codes=[ordered]@{};$queries=[ordered]@{};$names=[ordered]@{};$shapes=[ordered]@{}
    foreach($c in $Book.VBProject.VBComponents){$codes[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
    foreach($q in $Book.Queries){$queries[$q.Name]=$q.Formula}
    foreach($n in $Book.Names){$names[$n.Name]=$n.RefersTo}
    foreach($s in $Book.Worksheets){
        $items=@();foreach($p in $s.Shapes){$items+=@{name=$p.Name;left=$p.Left;top=$p.Top;width=$p.Width;height=$p.Height;action=$p.OnAction}}
        $shapes[$s.Name]=$items
    }
    @{codes=$codes;queries=$queries;names=$names;shapes=$shapes;links=@($Book.LinkSources(1));tim=$Book.Worksheets.Item('Tim').UsedRange.Formula2}
}
function PriceMap($Table) {
    $data=$Table.DataBodyRange.Value2;$result=@{}
    $id=$Table.ListColumns.Item('Index').Index;$price=$Table.ListColumns.Item('Unit Price 2').Index
    for($r=1;$r -le $data.GetLength(0);$r++){$result[[string]$data[$r,$id]]=$data[$r,$price]}
    $result
}
function CheckPrices($Table,$Mapping) {
    $values=PriceMap $Table
    Assert ($values.Count -eq $Mapping.Count) 'Unexpected Others row count.'
    foreach($r in $Mapping){Assert ([Math]::Abs([double]$values[[string]$r.index]-[double]$r.expected) -lt 0.000001) "Wrong price for Index $($r.index)"}
}
function RefreshTable($Table) {
    $result=$Table.QueryTable.Refresh($false)
    Assert $result "Refresh failed: $($Table.Name)"
    $Table.Parent.Application.CalculateUntilAsyncQueriesDone()
    $Table.Parent.Application.Calculate()
}
function RowFor($Table,$Index) {
    $ids=$Table.ListColumns.Item('Index').DataBodyRange.Value2
    for($r=1;$r -le $ids.GetLength(0);$r++){if($ids[$r,1] -eq $Index){return $r}}
    throw "Index $Index absent from $($Table.Name)"
}
$mapping=Get-Content -Raw -LiteralPath $Map | ConvertFrom-Json
$path=$File
if($Mode -eq 'Build'){
    Assert ($Output -and -not (Test-Path -LiteralPath $Output)) 'New output path required.'
    Copy-Item -LiteralPath $File -Destination $Output
    $path=$Output
}
$app=$null;$book=$null
try {
    $app=New-Object -ComObject Excel.Application
    $app.Visible=$false;$app.DisplayAlerts=$false;$app.EnableEvents=$false;$app.AutomationSecurity=3;$app.AskToUpdateLinks=$false
    $book=$app.Workbooks.Open($path,0,($Mode -eq 'Verify'))
    $openingMode=$app.Calculation
    if($Mode -eq 'Verify'){Assert ($openingMode -eq -4105) 'Delivered workbook did not open in Automatic mode.'}
    $before=Metadata $book
    $s=$book.Worksheets.Item('Others');$table=$s.ListObjects.Item('tblContractOthers')
    $app.Calculation=-4105
    Assert ($table.Range.Address() -eq '$A$4:$P$57') 'Unexpected Others layout.'
    # XLOOKUP returns zero for blank cells; COUNTIFS distinguishes a blank override from an explicit zero.
    $formula='=IF(COUNTIF(tblOthersPriceOverrides[Index],[@Index])>1,NA(),IF(COUNTIFS(tblOthersPriceOverrides[Index],[@Index],tblOthersPriceOverrides[Unit Price Override],"<>")=0,[@[Unit Price]],XLOOKUP([@Index],tblOthersPriceOverrides[Index],tblOthersPriceOverrides[Unit Price Override])))'
    if($Mode -eq 'Build') {
        Assert (-not $book.ReadOnly) 'Work copy is read-only.'
        Assert ($app.WorksheetFunction.CountA($s.Range('AA1:AD100')) -eq 0) 'Override area is occupied.'
        $s.Range('AA1:AD1').Merge();$s.Range('AA1').Value2='Others Price Overrides'
        $s.Range('AA1:AD1').Font.Bold=$true;$s.Range('AA1:AD1').Font.Size=14
        $s.Range('AA2:AD3').Merge();$s.Range('AA2').Value2='Match by Index. Blank override uses Contract price; zero is an explicit zero price.'
        $s.Range('AA2:AD3').WrapText=$true
        $headers=@('Index','Item','Unit Price Override','Mapping Note')
        for($c=0;$c -lt 4;$c++){$s.Cells.Item(4,27+$c).Value2=$headers[$c]}
        $values=New-Object 'object[,]' $mapping.Count,4
        for($r=0;$r -lt $mapping.Count;$r++){
            $values[$r,0]=[double]$mapping[$r].index;$values[$r,1]=[string]$mapping[$r].title
            if($null -ne $mapping[$r].override){$values[$r,2]=[double]$mapping[$r].override}
            $values[$r,3]=[string]$mapping[$r].basis
        }
        for($r=0;$r -lt $mapping.Count;$r++){
            for($c=0;$c -lt 4;$c++){
                if($null -ne $values[$r,$c]){
                    $s.Cells.Item($r+5,$c+27).Value2=[Convert]::ToString($values[$r,$c],[Globalization.CultureInfo]::InvariantCulture)
                    if($c -in @(0,2)){Assert ($s.Cells.Item($r+5,$c+27).Value2 -is [double]) 'Numeric table value was stored as text.'}
                }
            }
        }
        $overrides=$s.ListObjects.Add(1,$s.Range("AA4:AD$($mapping.Count+4)"),$null,1)
        $overrides.Name='tblOthersPriceOverrides';$overrides.TableStyle='TableStyleMedium5'
        $s.Columns.Item('AA').ColumnWidth=9;$s.Columns.Item('AB').ColumnWidth=27
        $s.Columns.Item('AC').ColumnWidth=22;$s.Columns.Item('AD').ColumnWidth=52
        $overrides.ListColumns.Item('Unit Price Override').DataBodyRange.NumberFormat='$#,##0.00;[Red]($#,##0.00)'
        $overrides.ListColumns.Item('Unit Price Override').DataBodyRange.Interior.Color=65535
        $overrides.ListColumns.Item('Index').DataBodyRange.Interior.Color=65535
        $overrides.ListColumns.Item('Mapping Note').DataBodyRange.WrapText=$true
        $s.Range('AA4:AD4').WrapText=$true
        $table.ListColumns.Item('Unit Price 2').DataBodyRange.Formula2=$formula
        $table.ListColumns.Item('Unit Price 2').DataBodyRange.Interior.Color=49407
        $app.Calculate()
        CheckPrices $table $mapping
        RefreshTable $table
        CheckPrices $table $mapping
        foreach($sheet in $book.Worksheets){
            foreach($t in $sheet.ListObjects){if($t.Name -in @('qryContractsToGnatt','qryGnattToDraws','tblUpdateContractOthers')){RefreshTable $t}}
        }
        $app.CalculateFullRebuild()
        CheckPrices $table $mapping
        $after=Metadata $book
        foreach($part in @('codes','queries','names','shapes','links','tim')){
            Assert (($before[$part]|ConvertTo-Json -Depth 30 -Compress) -ceq ($after[$part]|ConvertTo-Json -Depth 30 -Compress)) "Unexpected change: $part"
        }
        $book.Save()
        @{passed=$true;before=$before;after=$after;prices=(PriceMap $table);mode=$app.Calculation}|ConvertTo-Json -Depth 35|Set-Content -LiteralPath $Evidence -Encoding utf8
        # Export only after saving; temporary print changes are discarded.
        $s.PageSetup.PrintArea='$AA$1:$AD$30';$s.PageSetup.Orientation=2
        $s.PageSetup.Zoom=$false;$s.PageSetup.FitToPagesWide=1;$s.PageSetup.FitToPagesTall=1
        $s.ExportAsFixedFormat(0,[IO.Path]::ChangeExtension($Evidence,'.pdf'))
    } else {
        CheckPrices $table $mapping
        $overrides=$s.ListObjects.Item('tblOthersPriceOverrides')
        $orow=RowFor $overrides 45
        $cell=$overrides.ListColumns.Item('Unit Price Override').DataBodyRange.Cells.Item($orow,1)
        $cell.Value2='27'
        $actual=(PriceMap $table)['45']
        Assert ($actual -eq 27.0) 'Automatic override recalculation failed.'
        $cell.ClearContents()
        Assert ([Math]::Abs([double](PriceMap $table)['45']-26.1) -lt 0.000001) 'Blank override fallback failed.'
        # Sort the independent override table to prove matching does not depend on row position.
        $overrides.Sort.SortFields.Clear()
        [void]$overrides.Sort.SortFields.Add($overrides.ListColumns.Item('Index').DataBodyRange,0,2)
        $overrides.Sort.Header=1;$overrides.Sort.Apply()
        CheckPrices $table $mapping
        $base=$book.Worksheets.Item('Contract').ListObjects.Item('tblContractBase')
        $baseRow=RowFor $base 45
        $assigned=$base.ListColumns.Item('Assigned').DataBodyRange.Cells.Item($baseRow,1)
        $oldAssigned=$assigned.Value2
        $assigned.Value2='Glasgow DB'
        RefreshTable $table
        $minus=PriceMap $table
        Assert (-not $minus.ContainsKey('45')) 'Test item not removed by refresh.'
        foreach($r in $mapping){if($r.index -ne 45){Assert ([Math]::Abs([double]$minus[[string]$r.index]-[double]$r.expected) -lt 0.000001) "Refresh displaced Index $($r.index)"}}
        $assigned.Value2=$oldAssigned
        RefreshTable $table
        CheckPrices $table $mapping
        Assert ($table.ListColumns.Item('Unit Price 2').DataBodyRange.HasFormula -eq $true) 'Price formulas not retained after refresh.'
        @{passed=$true;automatic=$true;overrideEdit=$true;blankFallback=$true;overrideSort=$true;removeRestoreRefresh=$true;records=$mapping.Count;changesSaved=$false}|ConvertTo-Json|Set-Content -LiteralPath $Evidence -Encoding utf8
    }
    @{mode=$Mode;passed=$true;prices=(PriceMap $table)}|ConvertTo-Json -Depth 4
} catch {
    Write-Output $_.ScriptStackTrace
    throw
} finally {
    if($null -ne $book){$book.Close($false);[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($book)}
    if($null -ne $app){$app.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($app)}
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
