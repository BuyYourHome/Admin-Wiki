param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Output)
$ErrorActionPreference='Stop'
function Set-Cell($cell,$value){[void]$cell.GetType().InvokeMember('Value2',[Reflection.BindingFlags]::SetProperty,$null,$cell,@($value))}
function Note($cell,$text){if($cell.Comment){throw "Existing comment at $($cell.Address())"};[void]$cell.AddComment($text);$cell.Comment.Visible=$false}
if(Test-Path -LiteralPath $Output){throw 'Output already exists; do not overwrite a reviewed copy.'}
[void](New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Output))
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($Output,0,$false)
    $p=$b.Worksheets.Item('Profit');$s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    if($b.ReadOnly -or $b.Date1904 -or $t.ListRows.Count -ne 56 -or $p.Range('B2').Text -ne '4121 Tensity Dr'){throw 'Wrong source or changed baseline.'}
    if($e.WorksheetFunction.CountA($p.Range('Q18:W25')) -ne 0){throw 'Rent summary area is occupied.'}
    if($e.WorksheetFunction.CountIf($t.ListColumns.Item('Category').DataBodyRange,'Rent') -ne 0){throw 'Existing Rent requires reconciliation, not duplicate import.'}
    $e.Calculation=-4135
    # Source record dates identify monthly rental periods, not invented receipt dates.
    $lease='https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/24-HM%20-%204121%20Tensity%20Dr/Renting/25-07-01%20Ever%20Cardoza%20Rental%20Application%20and%20Lease%20SIGNED.pdf'
    $verification='https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B05C9AFB1-2B24-43EC-8C4C-EE3EC0303FA3%7D'
    for($m=0;$m -lt 12;$m++){
        $date=([datetime]'2025-07-01').AddMonths($m);$period=$date.ToString('yyyy-MM')
        $row=$t.ListRows.Add().Range
        $values=@('Yes','Rent',$date.ToOADate(),'Ever Cardoza',('Residential rent - '+$date.ToString('MMMM yyyy')),1850.0,'Lease + landlord verification',('TENSITY-RENT-'+$period),$lease,'Reported Collected',('Monthly allocation from June 5, 2026 landlord verification covering July 2025-June 2026. Date is rental month, not receipt date. No individual receipt or bank reconciliation supplied. Verification: '+$verification))
        for($c=1;$c -le 11;$c++){Set-Cell $row.Cells.Item(1,$c) $values[$c-1]}
        $row.Cells.Item(1,3).NumberFormat='m/d/yyyy';$row.Cells.Item(1,6).NumberFormat='#,##0.00;[Red](#,##0.00)'
    }
    # Do not insert rows into Profit or alter its existing planning inputs.
    $area=$p.Range('Q18:W25');$area.Font.Name=$p.Range('Q12').Font.Name;$area.Font.Size=10;$area.VerticalAlignment=-4108
    $p.Range('Q18:W18').Merge();Set-Cell $p.Range('Q18') 'Rent history';$p.Range('Q18').Font.Bold=$true
    $p.Range('Q18:W18').Interior.Color=14277081
    $labels=@('Rent collected','Months rented (recorded)','Of collected: landlord-reported','Lease rent awaiting confirmation','Hold: months still projected')
    for($r=19;$r -le 23;$r++){
        $p.Range("Q${r}:U${r}").Merge();$p.Range("V${r}:W${r}").Merge()
        Set-Cell $p.Range("Q$r") $labels[$r-19]
        $p.Range("Q$r").WrapText=$false;$p.Range("Q$r").ShrinkToFit=$true
        $p.Range("V${r}:W${r}").Interior.Color=49407;$p.Range("V$r").HorizontalAlignment=-4152
        $p.Range("V$r").NumberFormat='$#,##0.00;($#,##0.00)'
    }
    $sum='SUMIFS(tblCarryingExpenses[Amount],tblCarryingExpenses[Include],"Yes",tblCarryingExpenses[Category],"Rent",tblCarryingExpenses[Status],'
    $p.Range('V19').Formula2='='+$sum+'"Collected")+'+$sum+'"Reported Collected")'
    $p.Range('V21').Formula2='='+$sum+'"Reported Collected")'
    $p.Range('V22').Formula2='='+$sum+'"Scheduled")'
    $valid='(tblCarryingExpenses[Include]="Yes")*(tblCarryingExpenses[Category]="Rent")*ISNUMBER(d)*(d>0)*ISNUMBER(a)*(a>0)'
    $months='SUM(--(UNIQUE(FILTER(TEXT(IF(ISNUMBER(d),d,0),"yyyymm"),eligible,""))<>""))'
    $p.Range('V20').Formula2='=LET(d,tblCarryingExpenses[Date],s,tblCarryingExpenses[Status],a,tblCarryingExpenses[Amount],eligible,'+$valid+'*(d<=EOMONTH(TODAY(),0))*(((s="Collected")+(s="Reported Collected")+(s="Scheduled"))>0),'+$months+')'
    $p.Range('V23').Formula2='=LET(d,tblCarryingExpenses[Date],s,tblCarryingExpenses[Status],a,tblCarryingExpenses[Amount],eligible,'+$valid+'*(((s="Collected")+(s="Reported Collected")+(s="Scheduled")*(d<=EOMONTH(TODAY(),0)))>0),MAX(0,$B$9-'+$months+'))'
    $p.Range('V20').NumberFormat='0';$p.Range('V23').NumberFormat='0'
    [void]$b.Names.Add('rentTotalCollected',"='Profit'!`$V`$19")
    [void]$b.Names.Add('rentMonthsRented',"='Profit'!`$V`$20")
    [void]$b.Names.Add('rentMonthsProjected',"='Profit'!`$V`$23")
    $p.Range('Q24:W25').Merge();Set-Cell $p.Range('Q24') 'Dates identify rental months. Reported collections use landlord verification, not receipt-level reconciliation.'
    $p.Range('Q24').WrapText=$true;$p.Range('Q24').Font.Size=9
    $p.Range('E9').Formula2='=rentTotalCollected'
    $p.Range('A9').Formula2='=IF(E1=3,"CFD / Total Rent:","Monthly / Total Rent:")'
    $p.Range('K57').Formula2='=IF(OR($E$1=2,$E$1=3),K56*SUM(J10:K53)-IF($E$1=2,(MAX(0,$B$9)-rentMonthsProjected)*$C$9,0),0)'
    Note $p.Range('E9') 'Collected Rent income from Carrying, included once in every scenario. Collected and Reported Collected count; Scheduled, Entered and other unconfirmed statuses do not. Rent is never a Carrying expense.'
    Note $p.Range('B9') 'Existing total modeled rental horizon in months. This planning input is preserved. Actual recorded months appear in the Rent history block. Hold replaces elapsed/collected rental months within this horizon with actual collections; it does not add them to the same monthly-rent estimate.'
    Note $p.Range('K57') 'Hold retains the existing full-horizon cost model and monthly-rent input, subtracts the rent estimate for months already accounted for, and receives actual collected rent separately through E9. Slow Flip retains the existing CFD cash-flow model. B9 is the total modeled rental horizon, not additional future months.'
    Note $p.Range('V20') 'Distinct calendar rental months, not number of transactions. Included positive Rent records with status Scheduled, Collected or Reported Collected qualify through the current month. Split payments in one month count once. Date is the rental period, not receipt date. This is recorded occupancy, not an independent move-in/move-out audit.'
    Set-Cell $s.Range('AK9') 'Month';Set-Cell $s.Range('AL9') 'Rent'
    $s.Range('AK10:AK30').NumberFormat='mmm yyyy'
    Note $s.Range('AK9') 'For Rent, Date identifies the month the rent covers. Record receipt details in Notes/Source. Enter split payments under the same rental month; do not infer a receipt date from a lease due date.'
    Note $s.Range('AL31') 'All included Rent amounts, including schedules. Profit counts only Collected or Reported Collected; see Rent history on Profit. This subtotal is excluded from all Carrying expenses.'
    Note $s.Range('U6') 'Rent statuses: Scheduled = lease obligation only; Collected = confirmed receipt; Reported Collected = documented landlord report, not bank reconciliation. Entered does not count as collected. Never mark a recurring suggestion collected until supported.'
    $statuses='Entered,Migrated,Posted,Scheduled,Collected,Reported Collected,Hold,Missing Data,Do Not Move'
    foreach($range in @($s.Range('U6').MergeArea,$t.ListColumns.Item('Status').DataBodyRange)){
        $range.Validation.Delete();$range.Validation.Add(3,2,1,$statuses)
        $range.Validation.IgnoreBlank=$true;$range.Validation.InCellDropdown=$true
        $range.Validation.InputTitle='Rent collection status';$range.Validation.InputMessage='Scheduled is not income. Collected requires receipt support. Reported Collected requires a landlord report.'
        $range.Validation.ShowInput=$true;$range.Validation.ShowError=$false
    }
    $e.Calculation=-4105;$e.CalculateFullRebuild()
    if([math]::Abs($p.Range('V19').Value2-22200) -gt .001 -or $p.Range('V20').Value2 -ne 12 -or [math]::Abs($p.Range('B43').Value2-28224.97) -gt .001){throw 'Rent/expense reconciliation failed.'}
    $b.Save()
    [ordered]@{records=$t.ListRows.Count;collected=$p.Range('V19').Value2;months=$p.Range('V20').Value2;expenses=$p.Range('B43').Value2;file=$Output}|ConvertTo-Json
} finally {
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
