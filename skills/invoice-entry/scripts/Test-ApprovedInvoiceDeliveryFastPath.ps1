[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

function Get-ApprovedInvoiceDeliveryDecision {
    param(
        [bool]$ApprovalVerified,
        [bool]$Finalized,
        [bool]$InvoiceIdentityVerified,
        [bool]$ExactFiledPdfVerified,
        [bool]$PdfHashMatchesApproval,
        [bool]$DeliveryPackageAndRecipientsVerified,
        [ValidateSet("NoMatchingSend", "MatchingSendFound", "Ambiguous")]
        [string]$PriorSendState,
        [bool]$WorkbookPosted
    )

    $reasons = [System.Collections.Generic.List[string]]::new()
    foreach ($check in @(
        @{ Name = "ApprovalVerified"; Value = $ApprovalVerified },
        @{ Name = "Finalized"; Value = $Finalized },
        @{ Name = "InvoiceIdentityVerified"; Value = $InvoiceIdentityVerified },
        @{ Name = "ExactFiledPdfVerified"; Value = $ExactFiledPdfVerified },
        @{ Name = "PdfHashMatchesApproval"; Value = $PdfHashMatchesApproval },
        @{ Name = "DeliveryPackageAndRecipientsVerified"; Value = $DeliveryPackageAndRecipientsVerified }
    )) {
        if (-not $check.Value) { $reasons.Add("$($check.Name) is false.") }
    }

    if ($PriorSendState -eq "MatchingSendFound") {
        $reasons.Add("A matching send exists; reconcile its evidence and do not resend.")
    } elseif ($PriorSendState -eq "Ambiguous") {
        $reasons.Add("Prior submission is ambiguous; reconcile before any send.")
    }

    $eligible = $reasons.Count -eq 0 -and $PriorSendState -eq "NoMatchingSend"
    [pscustomobject]@{
        DeliveryEligible = $eligible
        DoNotResend = $PriorSendState -ne "NoMatchingSend"
        WorkbookPostingOutstanding = -not $WorkbookPosted
        WorkbookPostingBlocksDelivery = $false
        ParentWorkflowRemainsOpen = $true
        Reasons = @($reasons)
    }
}

function Assert-Equal {
    param($Expected, $Actual, [string]$Message)
    if ($Expected -ne $Actual) {
        throw "$Message Expected '$Expected', received '$Actual'."
    }
}

$base = @{
    ApprovalVerified = $true
    Finalized = $true
    InvoiceIdentityVerified = $true
    ExactFiledPdfVerified = $true
    PdfHashMatchesApproval = $true
    DeliveryPackageAndRecipientsVerified = $true
    PriorSendState = "NoMatchingSend"
    WorkbookPosted = $false
}

$fast = Get-ApprovedInvoiceDeliveryDecision @base
Assert-Equal $true $fast.DeliveryEligible "A fully verified, not-yet-sent approved PDF should use the fast path."
Assert-Equal $true $fast.WorkbookPostingOutstanding "Unposted workbook work must remain visible."
Assert-Equal $false $fast.WorkbookPostingBlocksDelivery "Workbook posting must not delay delivery."
Assert-Equal $true $fast.ParentWorkflowRemainsOpen "Delivery alone must not close the parent workflow."

$sentInput = $base.Clone()
$sentInput.PriorSendState = "MatchingSendFound"
$sent = Get-ApprovedInvoiceDeliveryDecision @sentInput
Assert-Equal $false $sent.DeliveryEligible "A matching prior send must not trigger another send."
Assert-Equal $true $sent.DoNotResend "A matching prior send must prohibit resend."

$ambiguousInput = $base.Clone()
$ambiguousInput.PriorSendState = "Ambiguous"
$ambiguous = Get-ApprovedInvoiceDeliveryDecision @ambiguousInput
Assert-Equal $false $ambiguous.DeliveryEligible "An ambiguous prior send must block delivery."

$badHashInput = $base.Clone()
$badHashInput.PdfHashMatchesApproval = $false
$badHash = Get-ApprovedInvoiceDeliveryDecision @badHashInput
Assert-Equal $false $badHash.DeliveryEligible "A PDF hash mismatch must block delivery."

$unapprovedInput = $base.Clone()
$unapprovedInput.ApprovalVerified = $false
$unapproved = Get-ApprovedInvoiceDeliveryDecision @unapprovedInput
Assert-Equal $false $unapproved.DeliveryEligible "Unverified approval must block delivery."

$badRecipientInput = $base.Clone()
$badRecipientInput.DeliveryPackageAndRecipientsVerified = $false
$badRecipient = Get-ApprovedInvoiceDeliveryDecision @badRecipientInput
Assert-Equal $false $badRecipient.DeliveryEligible "Unverified sender/recipient restrictions must block delivery."

[pscustomobject]@{
    passed = $true
    scenarios = 6
    verified_approved_pdf_fast_path = $fast.DeliveryEligible
    workbook_posting_blocks_delivery = $fast.WorkbookPostingBlocksDelivery
    parent_stays_open = $fast.ParentWorkflowRemainsOpen
    duplicate_and_ambiguity_protection = $sent.DoNotResend -and -not $ambiguous.DeliveryEligible
    hash_and_approval_gates = -not $badHash.DeliveryEligible -and -not $unapproved.DeliveryEligible
    recipient_restrictions_preserved = -not $badRecipient.DeliveryEligible
} | ConvertTo-Json
