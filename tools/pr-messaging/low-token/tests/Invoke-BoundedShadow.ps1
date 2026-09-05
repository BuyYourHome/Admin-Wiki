[CmdletBinding()]
param([ValidateRange(1,3)][int]$Ticks=3)
$ErrorActionPreference='Stop'
$release=Split-Path $PSScriptRoot -Parent
. "$release\Common.ps1"
. "$release\Process.ps1"
if($env:COMPUTERNAME -cne 'WES-VIDEOEDITOR' -or [Security.Principal.WindowsIdentity]::GetCurrent().Name -ine 'WES-VIDEOEDITOR\IRAMa'){throw 'NormalWveIdentityRequired'}
$ps=(Get-Command powershell.exe).Source
$manager='C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1'
$queue='\\WES-VIDEOEDITOR\BYH-PRMessaging$'
$auto='C:\Users\IRAMa\.codex\automations\pr-messaging-dispatcher-wes-videoeditor\automation.toml'
$started=[DateTime]::UtcNow
$out=Join-Path $env:LOCALAPPDATA ('BuyYourHome\PRMessaging\low-token\shadow-'+$started.ToString('yyyyMMddTHHmmssZ'))
$config=[ordered]@{schema_version=1;release='0.1.0';package_sha256=(Get-LtPackageHash $release);expected_machine=$env:COMPUTERNAME;expected_sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;dispatcher_task_id='01a05d0c-8031-7d92-9474-ab2330008ddb';fixture_root=$null;queue_path=$queue;manager_path=$manager;manager_sha256=(Get-FileHash $manager).Hash;client_path=(Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\client.json');manifest_directory='C:\Codex\Wiki Files\config\pr-messaging-manifests';state_directory=(Join-Path $out 'state');powershell_path=$ps;max_tick_seconds=25;acceptance_deadline_seconds=120}
Write-LtJson (Join-Path $out 'config.json') $config
$beforeAuto=(Get-FileHash $auto).Hash
function Snapshot {
    $p=Invoke-LtProcess $ps @('-NoProfile','-ExecutionPolicy','Bypass','-File',(Join-Path $release 'Invoke-ManagerCommand.ps1'),'-ManagerPath',$manager,'-ExpectedManagerHash',$config.manager_sha256,'-Action','List','-QueuePath',$queue) 15
    if($p.timed_out -or $p.exit_code -ne 0){throw ('CanonicalSnapshotFailed: '+$p.stderr)}
    try{$records=$p.stdout|ConvertFrom-Json}catch{throw ('CanonicalSnapshotInvalidJson: '+$_.Exception.GetType().FullName)}
    $fingerprints=@($records|Sort-Object message_id|ForEach-Object{@{message_id=$_.message_id;version=(Get-LtVersion $_)}})
    [pscustomobject]@{count=@($records).Count;digest=(Get-LtSha256 ($fingerprints|ConvertTo-Json -Depth 4 -Compress));legacy_candidate_count=@($records|Where-Object {$_.destination.machine -ceq $env:COMPUTERNAME -and $_.state -in @('Queued','Delivery Ambiguous')}).Count}
}
$before=Snapshot
$runs=@()
for($i=1;$i -le $Ticks;$i++){
    $p=Invoke-LtProcess $ps @('-NoProfile','-ExecutionPolicy','Bypass','-File',(Join-Path $release 'Invoke-LowTokenWorker.ps1'),'-ConfigPath',(Join-Path $out 'config.json'),'-Mode','Shadow') 30
    if($p.timed_out -or $p.exit_code -ne 0){throw ('ShadowProcessFailed: '+$p.stderr)}
    $r=$p.stdout|ConvertFrom-Json
    Write-LtJson (Join-Path $out ('tick-'+$i+'.json')) $r
    if($r.status -ne 'ShadowComplete' -or $r.claims -ne 0 -or $r.submissions -ne 0 -or $r.model_requests -ne 0){throw 'ShadowSafetyOrHealthFailure'}
    $runs+=@{tick=$i;status=$r.status;elapsed_ms=$r.elapsed_ms;candidate_count=@($r.candidates).Count;reasons=@($r.candidates|Group-Object reason|ForEach-Object{@{reason=$_.Name;count=$_.Count}});claims=$r.claims;submissions=$r.submissions;model_requests=$r.model_requests}
    if($i -lt $Ticks){Start-Sleep -Seconds 5}
}
$after=Snapshot
$result=[ordered]@{started_at_utc=$started.ToString('o');completed_at_utc=[DateTime]::UtcNow.ToString('o');machine=$env:COMPUTERNAME;identity=[Security.Principal.WindowsIdentity]::GetCurrent().Name;output_directory=$out;package_sha256=$config.package_sha256;before=$before;after=$after;queue_snapshot_unchanged=($before.digest -eq $after.digest);automation_unchanged=((Get-FileHash $auto).Hash -eq $beforeAuto);active_manager_unchanged=((Get-FileHash $manager).Hash -eq $config.manager_sha256);runs=$runs;central_mutations=0;cli_invocations=0;recurring_installation=$false;scope='Read-only canonical List, bounded shadow child ticks, profile-local evidence only'}
Write-LtJson (Join-Path $out 'shadow-results.json') $result
$result|ConvertTo-Json -Depth 10
