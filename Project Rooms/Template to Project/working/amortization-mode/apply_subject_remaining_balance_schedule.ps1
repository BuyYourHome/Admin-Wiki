$work = 'C:\Codex\Wiki Files\Project Rooms\Template to Project\working\amortization-mode\24_Project Management - 4121 Tensity Dr 2 - teams fetched 20260622-1652.xlsm'

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

function Set-WorkbookName($wb, $name, $refersTo) {
    foreach ($existing in @($wb.Names)) {
        if ($existing.Name -eq $name) {
            $existing.Delete()
            break
        }
    }
    $wb.Names.Add($name, $refersTo) | Out-Null
}

try {
    $wb = $excel.Workbooks.Open($work, $false, $false)
    $ws = $wb.Worksheets.Item('Amortization - Table Test')
    $subject = $ws.ListObjects.Item('tblSubjectToLoan')

    $ws.Range('A2').Value2 = 'Known Balance:'
    $ws.Range('A4').Value2 = 'Remaining Years/Months'
    $ws.Range('A6').Value2 = 'Known Balance Date:'

    Set-WorkbookName $wb 'subjectKnownBalance' "='Amortization - Table Test'!`$C`$2"
    Set-WorkbookName $wb 'subjectInterestRate' "='Amortization - Table Test'!`$C`$3"
    Set-WorkbookName $wb 'subjectRemainingYears' "='Amortization - Table Test'!`$C`$4"
    Set-WorkbookName $wb 'subjectRemainingMonths' "='Amortization - Table Test'!`$D`$4"
    Set-WorkbookName $wb 'subjectMonthlyPayment' "='Amortization - Table Test'!`$C`$5"
    Set-WorkbookName $wb 'subjectKnownBalanceDate' "='Amortization - Table Test'!`$C`$6"
    Set-WorkbookName $wb 'subjectMortgageEndDate' "='Amortization - Table Test'!`$C`$7"

    $ws.Range('D4').Formula = '=DATEDIF(subjectKnownBalanceDate,subjectMortgageEndDate,"m")+1'
    $ws.Range('C4').Formula = '=subjectRemainingMonths/12'
    $ws.Range('C5').Formula = '=ROUND(PMT(subjectInterestRate/12,subjectRemainingMonths,-subjectKnownBalance,0),2)'

    $subject.ListColumns.Item('Date').DataBodyRange.Formula = '=IF(ROW()=ROW(tblSubjectToLoan[#Headers])+1,subjectKnownBalanceDate,IF(OR(INDEX(tblSubjectToLoan[Date],ROW()-ROW(tblSubjectToLoan[#Headers])-1)="",INDEX(tblSubjectToLoan[Date],ROW()-ROW(tblSubjectToLoan[#Headers])-1)>=subjectMortgageEndDate),"",EDATE(INDEX(tblSubjectToLoan[Date],ROW()-ROW(tblSubjectToLoan[#Headers])-1),1)))'
    $subject.ListColumns.Item('Beg').DataBodyRange.Formula = '=IF([@Date]="",0,IF(ROW()=ROW(tblSubjectToLoan[#Headers])+1,subjectKnownBalance,MAX(0,INDEX(tblSubjectToLoan[Balance],ROW()-ROW(tblSubjectToLoan[#Headers])-1))))'
    $subject.ListColumns.Item('Payment').DataBodyRange.Formula = '=IF([@Date]="",0,IF([@Beg]<=0,0,IF([@Date]>=subjectMortgageEndDate,[@Beg]+[@Int],MIN(subjectMonthlyPayment,[@Beg]+[@Int]))))'
    $subject.ListColumns.Item('Princ').DataBodyRange.Formula = '=IF([@Payment]=0,0,MAX(0,MIN([@Beg],[@Payment]-[@Int])))'
    $subject.ListColumns.Item('Int').DataBodyRange.Formula = '=IF([@Date]="",0,ROUND([@Beg]*(subjectInterestRate/12),2))'
    $subject.ListColumns.Item('Total ').DataBodyRange.Formula = '=SUM([@Princ],[@Int],[@Ins],[@Taxes])'
    $subject.ListColumns.Item('Principal').DataBodyRange.Formula = '=IF([@Date]="",IF(ROW()=ROW(tblSubjectToLoan[#Headers])+1,0,INDEX(tblSubjectToLoan[Principal],ROW()-ROW(tblSubjectToLoan[#Headers])-1)),[@Princ]+IF(ROW()=ROW(tblSubjectToLoan[#Headers])+1,0,INDEX(tblSubjectToLoan[Principal],ROW()-ROW(tblSubjectToLoan[#Headers])-1)))'
    $subject.ListColumns.Item('Interest').DataBodyRange.Formula = '=IF([@Date]="",IF(ROW()=ROW(tblSubjectToLoan[#Headers])+1,0,INDEX(tblSubjectToLoan[Interest],ROW()-ROW(tblSubjectToLoan[#Headers])-1)),[@Int]+IF(ROW()=ROW(tblSubjectToLoan[#Headers])+1,0,INDEX(tblSubjectToLoan[Interest],ROW()-ROW(tblSubjectToLoan[#Headers])-1)))'
    $subject.ListColumns.Item('Balance').DataBodyRange.Formula = '=IF([@Date]="",0,MAX(0,[@Beg]-[@Princ]))'

    $wb.ForceFullCalculation = $true
    $excel.CalculateFullRebuild()
    $wb.Save()
    $wb.Close($true)
}
finally {
    if ($excel) {
        $excel.Quit()
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
}
