Set-StrictMode -Version 2

function Assert-LtPackagedCliStaticEvidence($Evidence) {
    if(!$Evidence.exists){throw 'CliExecutableMissing'}
    if($Evidence.file_name -cne 'codex.exe' -or $Evidence.is_reparse){throw 'UnreviewedCliLocation'}
    if($Evidence.package_name -cne 'OpenAI.Codex' -or
        $Evidence.package_publisher -cne 'CN=50BDFD77-8903-4850-9FFE-6E8522F64D5B' -or
        $Evidence.package_family_name -cne 'OpenAI.Codex_2p2nqsd0c76g0' -or
        $Evidence.package_architecture -cne 'X64' -or
        $Evidence.package_full_name -cnotmatch '^OpenAI\.Codex_[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+_x64__2p2nqsd0c76g0$'){
        throw 'UnreviewedCliPackageIdentity'
    }
    $install=[IO.Path]::GetFullPath([string]$Evidence.install_location).TrimEnd('\')
    $windowsApps=[IO.Path]::GetFullPath('C:\Program Files\WindowsApps').TrimEnd('\')+'\'
    if(!$install.StartsWith($windowsApps,[StringComparison]::OrdinalIgnoreCase) -or
        [IO.Path]::GetFileName($install) -cne $Evidence.package_full_name){throw 'UnreviewedCliPackageLocation'}
    $expected=[IO.Path]::GetFullPath((Join-Path $install 'app\resources\codex.exe'))
    if([IO.Path]::GetFullPath([string]$Evidence.path) -cne $expected){throw 'UnreviewedCliLocation'}
    if($Evidence.manifest_name -cne $Evidence.package_name -or
        $Evidence.manifest_publisher -cne $Evidence.package_publisher -or
        $Evidence.manifest_architecture -cne 'x64' -or
        $Evidence.manifest_version -cne $Evidence.package_version){throw 'UnreviewedCliManifestIdentity'}
    if($Evidence.signature_status -cne 'Valid' -or
        $Evidence.signer_subject -cne 'CN="OpenAI OpCo, LLC", O="OpenAI OpCo, LLC", L=San Francisco, S=California, C=US'){
        throw 'UnreviewedCliSignature'
    }
    if([string]$Evidence.sha256_before -cnotmatch '^[0-9A-Fa-f]{64}$'){throw 'UnreviewedCliHash'}
}

function Assert-LtPackagedCliEvidence($Evidence) {
    Assert-LtPackagedCliStaticEvidence $Evidence
    if([int]$Evidence.version_exit_code -ne 0 -or [string]$Evidence.version_output -cnotmatch '^codex-cli [0-9A-Za-z][0-9A-Za-z.+-]*$'){
        throw 'UnreviewedCliBehavior'
    }
    if([string]$Evidence.sha256_after -ine [string]$Evidence.sha256_before){throw 'CliChangedDuringReview'}
}

function Get-LtReviewedCli {
    $command=Get-Command codex.exe -ErrorAction SilentlyContinue
    if(!$command -or [string]::IsNullOrWhiteSpace([string]$command.Source)){throw 'CliExecutableMissing'}
    $path=[IO.Path]::GetFullPath($command.Source)
    if(!(Test-Path -LiteralPath $path -PathType Leaf)){throw 'CliExecutableMissing'}
    $item=Get-Item -LiteralPath $path -Force -ErrorAction Stop
    if($item.Name -cne 'codex.exe' -or ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)){throw 'UnreviewedCliLocation'}

    $localRoot=[IO.Path]::GetFullPath((Join-Path $env:LOCALAPPDATA 'OpenAI\Codex\bin')).TrimEnd('\')+'\'
    if($path.StartsWith($localRoot,[StringComparison]::OrdinalIgnoreCase)){
        if($item.Directory.Name -cnotmatch '^[0-9a-f]{8,64}$'){throw 'UnreviewedCliLocation'}
        return [pscustomobject]@{path=$path;sha256=(Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash;trust_model='ReviewedLocalCodexBin';package_full_name=$null;version_output=$null}
    }

    $windowsApps=[IO.Path]::GetFullPath('C:\Program Files\WindowsApps').TrimEnd('\')+'\'
    if(!$path.StartsWith($windowsApps,[StringComparison]::OrdinalIgnoreCase)){throw 'UnreviewedCliLocation'}
    $packages=@(Get-AppxPackage -Name 'OpenAI.Codex' -ErrorAction Stop | Where-Object {
        $location=[IO.Path]::GetFullPath([string]$_.InstallLocation).TrimEnd('\')+'\'
        $path.StartsWith($location,[StringComparison]::OrdinalIgnoreCase)
    })
    if($packages.Count -ne 1){throw 'UnreviewedCliPackageIdentity'}
    $package=$packages[0]
    $manifest=Get-AppxPackageManifest -Package $package.PackageFullName -ErrorAction Stop
    $signature=Get-AuthenticodeSignature -LiteralPath $path
    $before=(Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
    $evidence=[pscustomobject]@{
        exists=$true;path=$path;file_name=$item.Name;is_reparse=[bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
        package_name=[string]$package.Name;package_publisher=[string]$package.Publisher;package_family_name=[string]$package.PackageFamilyName
        package_architecture=[string]$package.Architecture;package_version=[string]$package.Version;package_full_name=[string]$package.PackageFullName
        install_location=[string]$package.InstallLocation;manifest_name=[string]$manifest.Package.Identity.Name
        manifest_publisher=[string]$manifest.Package.Identity.Publisher;manifest_architecture=[string]$manifest.Package.Identity.ProcessorArchitecture
        manifest_version=[string]$manifest.Package.Identity.Version;signature_status=[string]$signature.Status
        signer_subject=if($signature.SignerCertificate){[string]$signature.SignerCertificate.Subject}else{''}
        sha256_before=$before;version_exit_code=$null;version_output=$null;sha256_after=$null
    }
    Assert-LtPackagedCliStaticEvidence $evidence
    $versionOutput=(& $path --version 2>&1 | Out-String).Trim()
    $evidence.version_exit_code=$LASTEXITCODE
    $evidence.version_output=$versionOutput
    $evidence.sha256_after=(Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
    Assert-LtPackagedCliEvidence $evidence
    [pscustomobject]@{path=$path;sha256=$evidence.sha256_after;trust_model='RegisteredSignedOpenAICodexPackage';package_full_name=$evidence.package_full_name;version_output=$versionOutput}
}
