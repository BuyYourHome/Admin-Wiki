$ErrorActionPreference = "Stop"

$projectDocx = "C:\Codex\Wiki Files\Project Rooms\Credit Worthiness Evaluator\outputs\320 Rose Pl - Ever Cardoza\26-06-11 320 Rose Ever Amarildo Cardoza Bolanos - Creditworthiness Evaluation Report - Document Preparation Ready v24.docx"
$teamsDocx = "C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28-SYH-320 Rose Pl\Selling\Ever Cordoza\Contract Package\Clean Package\320 Rose Ever Amarildo Cardoza Bolanos - Creditworthiness Evaluation Report - Document Preparation Ready.docx"
$archiveDir = "C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28-SYH-320 Rose Pl\Selling\Ever Cordoza\Contract Package\Clean Package\Credit Worthiness Archive"
$footerVersion = "26-06-11 V24"

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $projectDocx) | Out-Null
New-Item -ItemType Directory -Force -Path $archiveDir | Out-Null

if (Test-Path -LiteralPath $teamsDocx) {
    $base = Split-Path -Leaf $teamsDocx
    $i = 3
    do {
        $archivePath = Join-Path $archiveDir ("v$i " + $base)
        $i++
    } while (Test-Path -LiteralPath $archivePath)
    Move-Item -LiteralPath $teamsDocx -Destination $archivePath
}

if (Test-Path -LiteralPath $projectDocx) {
    Remove-Item -LiteralPath $projectDocx -Force
}

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
$doc = $word.Documents.Add()

function Add-Para($text, $bold = $false, $size = 10, $style = "") {
    $p = $doc.Paragraphs.Add()
    if ($style -ne "") { $p.Range.Style = $style }
    $p.Range.Text = $text
    $p.Range.Font.Name = "Aptos"
    $p.Range.Font.Size = $size
    $p.Range.Font.Bold = [int]$bold
    $p.SpaceAfter = 6
    $p.Range.InsertParagraphAfter()
    return $p
}

function Add-Heading($text) {
    Add-Para $text $true 12 "Heading 1" | Out-Null
}

function Add-Bullet($text) {
    $p = Add-Para $text $false 10
    $p.Range.ListFormat.ApplyBulletDefault()
}

function Add-Table($rows) {
    $range = $doc.Range($doc.Content.End - 1, $doc.Content.End - 1)
    $table = $doc.Tables.Add($range, $rows.Count, $rows[0].Count)
    $table.Borders.Enable = 1
    $table.Range.Font.Name = "Aptos"
    $table.Range.Font.Size = 9
    for ($r = 0; $r -lt $rows.Count; $r++) {
        for ($c = 0; $c -lt $rows[$r].Count; $c++) {
            $cell = $table.Cell($r + 1, $c + 1)
            $cell.Range.Text = [string]$rows[$r][$c]
            if ($r -eq 0) { $cell.Range.Font.Bold = 1 }
            $cell.VerticalAlignment = 0
        }
    }
    $table.AutoFitBehavior(1)
    $doc.Paragraphs.Add() | Out-Null
}

function Add-Callout($title, $body) {
    Add-Table @(
        @($title),
        @($body)
    )
}

$doc.PageSetup.TopMargin = 46.8
$doc.PageSetup.BottomMargin = 46.8
$doc.PageSetup.LeftMargin = 50.4
$doc.PageSetup.RightMargin = 50.4

Add-Para "UPDATED CREDITWORTHINESS EVALUATION REPORT" $true 14 | Out-Null
Add-Para "Document-preparation readiness rerun for Ever Amarildo Cardoza Bolanos and Maria Geraldina Sarmiento, 320 Rose Pl, Wendell, North Carolina" $false 10 | Out-Null

Add-Table @(
    @("Prepared by", "Investment Services, LLC"),
    @("Report date", "June 11, 2026"),
    @("Subject buyer", "Ever Amarildo Cardoza Bolanos"),
    @("Additional signing buyer from spreadsheet", "Maria Geraldina Sarmiento"),
    @("Property", "320 Rose Pl, Wendell, NC 27591"),
    @("Purpose", "Current evidence rerun for Sell Your Home, LLC document-preparation decision and Contract for Deed closing-package support."),
    @("Overall result", "Ready for document preparation; closing execution remains subject to required affidavits, funds proof, final legal-name/spelling confirmation, and attorney/compliance review.")
)

Add-Callout "Executive Recommendation" "Proceed with Contract for Deed document preparation. The current file is supportable for document preparation based on verified rent history with related company Buy Your Home, LLC, satisfactory screening/credit indicators, observed business cash flow, and affidavit-supported business judgment. The file should not be marked ready for closing execution until closing deliverables are completed, funds-to-close are proved or accepted by the closing process, buyer name spelling is confirmed, and counsel/compliance review confirms the seller-financing and Contract for Deed package."

Add-Heading "1. What Changed In This Rerun"
Add-Para "This rerun replaces the prior DOCX with a Microsoft Word-native document because Wes reported that the previous current Teams copy opened with an error and displayed nothing. The substantive evaluation result is unchanged from the current evidence review." | Out-Null
Add-Para "The live project spreadsheet identifies Ever Amarildo Cardoza Bolanos as Selling-Buyer1 and Maria Geraldina Sarmiento as Selling-Buyer2. It shows Sell Your Home, LLC as seller, a purchase price of $346,500, loan amount of $325,710, monthly payment of $2,504.43, and manager field of Jose Fabre Jr." | Out-Null

Add-Heading "2. Transaction Snapshot"
Add-Table @(
    @("Item", "Current source value"),
    @("Buyer 1", "Ever Amarildo Cardoza Bolanos"),
    @("Buyer 2 / signing buyer", "Maria Geraldina Sarmiento"),
    @("Buyer address", "4121 Tensity Dr, Raleigh, NC 27604"),
    @("Seller", "Sell Your Home, LLC"),
    @("Property", "320 Rose Pl, Wendell, NC 27591"),
    @("County", "Wake County, North Carolina"),
    @("Purchase price", "$346,500.00"),
    @("Earnest money", "$6,000.00"),
    @("Down payment", "$20,790.00"),
    @("Loan amount", "$325,710.00"),
    @("Monthly payment", "$2,504.43"),
    @("Loan start / end", "July 1, 2026 / June 1, 2056"),
    @("Trustee", "Investment Services LLC"),
    @("Manager field in spreadsheet", "Jose Fabre Jr.")
)

Add-Heading "3. Screening Strengths"
Add-Para "The Zillow screening materials identify Ever Amarildo Cardoza as identity verified, self-employed, and residing at 4121 Tensity Dr since June 1, 2025. The stated monthly self-employment income is $9,500." | Out-Null
Add-Para "The credit report dated June 5, 2026 shows a 706 VantageScore 4.0, 100% on-time payments, no collections found, and no bankruptcies found. Reported monthly debt payments are $2,162, with total debt of $86,790." | Out-Null

Add-Heading "4. Ability-To-Repay Findings"
Add-Para "On strict underwriting evidence, borrower-level net self-employment income remains incompletely documented because the file still lacks tax returns, a profit-and-loss statement, payroll records, or an owner-draw analysis. The evaluator should not convert gross business receipts into verified personal net income without those records." | Out-Null
Add-Para "For document-preparation readiness, the file remains supportable because the proposed housing payment is only $654.43 above the verified related-company rent of $1,850, the buyer has a direct rent-payment track record with Buy Your Home, LLC, and the available business records show sustained gross activity sufficient to support a business-judgment review." | Out-Null

Add-Heading "5. Income And Business Cash Flow"
Add-Table @(
    @("Metric", "Current evidence"),
    @("Applicant-stated self-employed income", "$9,500.00 per month"),
    @("Business bank statements reviewed", "17 statement periods summarized"),
    @("Average business deposits", "$27,773.92 per month"),
    @("Average business withdrawals", "$27,622.03 per month"),
    @("Total business deposits summarized", "$472,156.56"),
    @("Total business withdrawals summarized", "$469,574.46"),
    @("Latest business ending balance", "$5,058.11"),
    @("Personal bank statements summarized", "12 statement periods; average deposits $2,040.14 per month"),
    @("Receipts/receivables", "Receipt packages support gross receipts only; they do not establish borrower-level net income by themselves.")
)

Add-Heading "6. Debt Burden"
Add-Table @(
    @("Debt item", "Amount / status"),
    @("Credit-report estimated monthly payments", "$2,162.00"),
    @("Total reported debt", "$86,790"),
    @("Collections", "None found"),
    @("Bankruptcies", "None found"),
    @("Current rent verified by related company", "$1,850.00 per month"),
    @("Increase from verified rent to proposed payment", "$654.43 per month")
)

Add-Heading "7. Payment Ratios"
Add-Table @(
    @("Ratio test", "Calculation", "Result"),
    @("Housing ratio using stated income", "$2,504.43 / $9,500.00", "26.4%"),
    @("Back-end ratio using stated income", "($2,504.43 + $2,162.00) / $9,500.00", "49.1%"),
    @("Increase over verified rent", "$2,504.43 - $1,850.00", "$654.43")
)
Add-Para "Using stated income, the back-end ratio is approximately 49.1%. That ratio is elevated, but it is not by itself a document-preparation stop when the seller/business decides to proceed based on the buyer's verified rent history, credit performance, and required closing affidavits." | Out-Null

Add-Heading "8. Cash To Close And Reserves"
Add-Para "The spreadsheet requires $6,000 earnest money and total down payment of $20,790. Current support materials include an affidavit package addressing observed cash, receivables, and foreign-fund access, but the file still needs final funds-to-close proof or closing-accepted handling before execution." | Out-Null
Add-Table @(
    @("Item", "Status"),
    @("Earnest money", "Spreadsheet shows $6,000; final proof/receipt handling still required."),
    @("Remaining down payment", "Total down payment shown as $20,790; final closing proof still required."),
    @("Cash/reserve observation affidavit", "Useful support if signed/notarized and accepted by counsel/closing process."),
    @("Receivables", "Do not count as liquid reserves unless collection is proved or accepted by closing reviewer.")
)

Add-Heading "9. Decision"
Add-Callout "Decision" "Credit/evaluation status: supportable for document preparation under a business-judgment and closing-deliverables approach. Closing-package readiness status: Ready for document preparation. Not ready for closing execution until listed closing deliverables and legal/compliance review are complete."

Add-Heading "10. Conditions Or Documents Required Before Approval/Closing"
Add-Bullet "Signed/notarized support affidavits or counsel-approved substitutes."
Add-Bullet "Final proof or closing-accepted handling for earnest money, down payment, closing costs, and any expected post-closing reserves."
Add-Bullet "Final legal-name spelling confirmation for Ever Amarildo Cardoza Bolanos and Maria Geraldina Sarmiento."
Add-Bullet "Resolution of any signature-authority conflict created by spreadsheet manager fields versus affidavit or prior workflow materials."
Add-Bullet "Attorney/compliance review of seller-financing, ability-to-repay, disclosure, state Contract for Deed, title, recording, notice, and adverse-action issues."

Add-Heading "11. CFD Closing-Package Document Requests"
Add-Table @(
    @("Requested item", "Purpose", "Status"),
    @("Affidavit of Related-Company Rent Payment History", "Documents rent history with Buy Your Home, LLC and related-company limitation.", "Closing deliverable if relied on."),
    @("Affidavit of Cash Reserves and Receivables Observation", "Supports observed cash/reserve/receivable facts without overstating collection or transfer.", "Closing deliverable or substitute proof needed."),
    @("Affidavit of Receipt Package Review and Acceptance", "Documents business acceptance of paid receipts as gross-receipt support, not net-income proof.", "Closing deliverable if receipts are relied on."),
    @("Affidavit of Business Judgment Approval Direction", "Documents management decision to proceed despite nonstandard income proof and elevated back-end ratio.", "Closing deliverable if management proceeds on this basis; update payment/authority values before final use.")
)

Add-Heading "12. Legal/Compliance Review Items"
Add-Bullet "Confirm whether the transaction is subject to TILA/Regulation Z, Dodd-Frank ability-to-repay requirements, and/or any seller-financer exclusion."
Add-Bullet "Confirm North Carolina Contract for Deed requirements, recording/notice duties, title/adverse-condition handling, and disclosure package sufficiency."
Add-Bullet "Confirm seller, trust/trustee, manager, and exact signature authority for Sell Your Home, LLC / Investment Services LLC / project spreadsheet fields."
Add-Bullet "Confirm whether adverse-action notice or similar documentation is needed if any term or approval condition is considered less favorable than requested."

Add-Heading "13. Recommended Next Step"
Add-Para "Proceed with preparation of the Contract for Deed closing package, including the listed affidavit/support deliverables. Before execution, obtain final funds proof or closing-accepted substitute documentation, confirm buyer legal names and signature roles, resolve manager/signature authority, and complete attorney/compliance review." | Out-Null

$footerRange = $doc.Sections.Item(1).Footers.Item(1).Range
$footerRange.ParagraphFormat.Alignment = 1
$footerRange.Text = "Page "
$footerRange.Collapse(0)
$doc.Fields.Add($footerRange, 33) | Out-Null
$footerRange = $doc.Sections.Item(1).Footers.Item(1).Range
$footerRange.Collapse(0)
$footerRange.InsertAfter(" of ")
$footerRange.Collapse(0)
$doc.Fields.Add($footerRange, 26) | Out-Null
$footerRange = $doc.Sections.Item(1).Footers.Item(1).Range
$footerRange.Collapse(0)
$footerRange.InsertAfter(" | $footerVersion")

$doc.SaveAs2($projectDocx, 16)
$doc.SaveAs2($teamsDocx, 16)
$doc.Close($false)
$word.Quit()

Write-Output "PROJECT_DOCX=$projectDocx"
Write-Output "TEAMS_DOCX=$teamsDocx"
if ($archivePath) { Write-Output "ARCHIVED_PREVIOUS=$archivePath" }
