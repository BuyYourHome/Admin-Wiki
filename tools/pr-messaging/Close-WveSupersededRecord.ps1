[CmdletBinding()]
param([switch]$Apply)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Message-Integrity.ps1"
if($env:COMPUTERNAME -cne 'WES-VIDEOEDITOR' -or [Security.Principal.WindowsIdentity]::GetCurrent().Name -ine 'WES-VIDEOEDITOR\IRAMa'){throw 'NormalWveIdentityRequired'}
$manager=Join-Path $PSScriptRoot 'Manage-ProjectRoomMessage.ps1'
$id='prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-001'
$actor='01a05d0c-8031-7d92-9474-ab2330008ddb'
$queue='\\WES-VIDEOEDITOR\BYH-PRMessaging$'
$r=(& $manager -Action Get -MessageId $id)|ConvertFrom-Json
if(!(Test-PrSupersededRecord $r)){throw 'ExactSupersededRecordRequired'}
$version=Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress)
if(!$Apply){[pscustomobject]@{message_id=$id;state=$r.state;payload_hash=$r.payload_hash;record_version=$version;already_closed=(Test-PrAdministrativeClosure $r);apply_performed=$false}|ConvertTo-Json;return}
if(Test-PrAdministrativeClosure $r){[pscustomobject]@{message_id=$id;already_closed=$true;apply_performed=$false;closure=$r.administrative_closure}|ConvertTo-Json -Depth 6;return}
$out=Join-Path $env:LOCALAPPDATA ('BuyYourHome\PRMessaging\recovery\administrative-closure-'+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ')+'-'+[guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $out|Out-Null
$recordPath=Join-Path $queue ('records\'+$id+'.json')
$backup=Join-Path $out ($id+'.before.json')
Copy-Item -LiteralPath $recordPath -Destination $backup
function Fingerprints { $map=@{};Get-ChildItem -LiteralPath (Join-Path $queue 'records') -File -Filter '*.json'|ForEach-Object{$map[$_.Name]=(Get-FileHash -LiteralPath $_.FullName).Hash};return $map }
$before=Fingerprints
$applied=(& $manager -Action AdministrativeCloseSuperseded -MessageId $id -ActorProjectRoom 'PR Messaging Dispatcher' -ActorTaskId $actor -ExpectedRecordVersion $version)|ConvertFrom-Json
$verified=(& $manager -Action Get -MessageId $id)|ConvertFrom-Json
$after=Fingerprints
$changed=@(@($before.Keys)+@($after.Keys)|Sort-Object -Unique|Where-Object{$before[$_] -cne $after[$_]})
$historyBefore=[ordered]@{state=$r.state;attempts=$r.attempts;attempt_count=$r.attempt_count;receipt=$r.receipt;result=$r.result}|ConvertTo-Json -Depth 30 -Compress
$historyAfter=[ordered]@{state=$verified.state;attempts=$verified.attempts;attempt_count=$verified.attempt_count;receipt=$verified.receipt;result=$verified.result}|ConvertTo-Json -Depth 30 -Compress
$ok=(Test-PrAdministrativeClosure $verified) -and $historyBefore -ceq $historyAfter -and $changed.Count -eq 1 -and $changed[0] -ceq ($id+'.json')
$evidence=[ordered]@{completed_at_utc=[DateTime]::UtcNow.ToString('o');message_id=$id;apply_performed=$true;verified=$ok;state=$verified.state;closure=$verified.administrative_closure;attempt_history_receipt_result_preserved=($historyBefore -ceq $historyAfter);changed_record_files=$changed;backup_path=$backup;backup_sha256=(Get-FileHash $backup).Hash;after_sha256=(Get-FileHash $recordPath).Hash;production_claims=0;notifications=0;business_actions=0}
$json=$evidence|ConvertTo-Json -Depth 8
[IO.File]::WriteAllText((Join-Path $out 'closure-evidence.json'),$json,[Text.UTF8Encoding]::new($false))
$json
if(!$ok){throw 'AdministrativeClosureVerificationFailed; do not repeat or alter records; reconcile evidence'}
