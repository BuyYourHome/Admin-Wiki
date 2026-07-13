$ErrorActionPreference = "Stop"
$path = "C:\Codex\Wiki Files\Project Rooms\Template to Project\Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate 20260531_104328.xlsm"
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$excel.EnableEvents = $false
$wb = $null
try {
    $wb = $excel.Workbooks.Open($path, 0, $true)
    $items = @()
    foreach ($conn in @($wb.Connections)) {
        $items += [pscustomobject]@{ Kind = "Connection"; Name = $conn.Name; Type = $conn.Type }
    }
    foreach ($ws in @($wb.Worksheets)) {
        foreach ($lo in @($ws.ListObjects)) {
            $items += [pscustomobject]@{ Kind = "Table"; Name = $lo.Name; Sheet = $ws.Name; SourceType = $lo.SourceType }
        }
    }
    $items | ConvertTo-Json -Depth 4
}
finally {
    if ($null -ne $wb) { try { $wb.Close($false) } catch {} }
    if ($null -ne $excel) {
        try { $excel.Quit() } catch {}
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
}
