<#
Non-interactive build script for M365Documentation PowerShell module.
- Bumps patch (Build) version by 1
- Updates module manifest (FunctionsToExport, ReleaseNotes, RequiredModules, IconUri, ModuleVersion)
- Runs PSScriptAnalyzer
- Creates a dist/<module>-<version>.zip artifact
- Optional signing if environment variable CERT_THUMBPRINT is set (uses cert in CurrentUser\My)

Usage:
pwsh -NoProfile -ExecutionPolicy Bypass -File .\PSModule\build-noninteractive.ps1

Note: This script does not publish to PSGallery. To publish, run the interactive `PSModule\build.ps1` or call Publish-Module manually with your API key.
#>

$ModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'M365Documentation'
$ManifestPath = Join-Path -Path $ModulePath -ChildPath 'M365Documentation.psd1'
$ReleaseNotesFile = Join-Path -Path $PSScriptRoot -ChildPath '..\..\ReleaseNotes.md'
$DistPath = Join-Path -Path $PSScriptRoot -ChildPath 'dist'

Write-Host "Module path: $ModulePath"
Write-Host "Manifest path: $ManifestPath"

if (-not (Test-Path $ManifestPath)) { Write-Error "Manifest not found at $ManifestPath"; exit 1 }

# Read manifest and compute new version
$manifestInfo = Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop
$currentVersion = [Version]::Parse($manifestInfo.Version.ToString())
$newVersion = [Version]::new($currentVersion.Major, $currentVersion.Minor, $currentVersion.Build + 1)

Write-Host "Current version: $currentVersion -> New version: $newVersion"

# Build ReleaseNotes short summary (first section)
$releaseNotes = ''
if (Test-Path $ReleaseNotesFile) {
    try {
        $content = Get-Content -Path $ReleaseNotesFile -Raw -ErrorAction Stop
        $parts = $content -split "##" 
        if ($parts.Count -gt 1) { $releaseNotes = ($parts[1].Trim() + "`n`n To see the complete history, checkout the Release Notes on Github") }
    } catch {
        Write-Warning "Could not read ReleaseNotes.md: $_"
    }
}

# Build FunctionsToExport list
$ExportableFunctions = (Get-ChildItem -Path (Join-Path $ModulePath 'Functions') -Filter '*.ps1' -ErrorAction Stop).BaseName

# Update manifest
Write-Host "Updating module manifest..."
Update-ModuleManifest -Path $ManifestPath `
    -FunctionsToExport $ExportableFunctions `
    -ReleaseNotes $releaseNotes `
    -RequiredModules @('MSAL.PS','PSWriteOffice') `
    -IconUri 'https://raw.githubusercontent.com/ThomasKur/M365Documentation/main/Logo/M365DocumentationLogo.png' `
    -ModuleVersion $newVersion `
    -ExternalModuleDependencies @('MSAL.PS','PSWriteOffice')  `
    -ErrorAction Stop

Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop

# Run PSScriptAnalyzer
Write-Host "Running PSScriptAnalyzer..."
Import-Module PSScriptAnalyzer -Force
$analysis = Invoke-ScriptAnalyzer -Path $ModulePath -Recurse -ErrorAction Stop -ExcludeRule @('PSAvoidTrailingWhitespace')
if ($analysis) {
    Write-Host "PSScriptAnalyzer warnings/errors:" -ForegroundColor Yellow
    $analysis | Format-Table -AutoSize
    # treat warnings as non-fatal; fail only on errors with Severity 'Error'
    $errors = $analysis | Where-Object { $_.Severity -eq 'Error' }
    if ($errors) {
        Write-Error "PSScriptAnalyzer found errors; aborting build."
        exit 2
    }
} else {
    Write-Host "PSScriptAnalyzer: no findings"
}

# Optional signing using cert thumbprint from env CERT_THUMBPRINT
$certThumb = $env:CERT_THUMBPRINT
$signingEnabled = $false
if ($certThumb) {
    try {
        $cert = Get-Item -Path "Cert:\CurrentUser\My\$certThumb" -ErrorAction Stop
        if ($cert -and $cert.HasPrivateKey) { $signingEnabled = $true; Write-Host "Code signing enabled with cert $certThumb" }
    } catch {
        Write-Warning "CERT_THUMBPRINT set but certificate not found: $certThumb"; $signingEnabled = $false
    }
}

# Prepare dist
if (-not (Test-Path $DistPath)) { New-Item -Path $DistPath -ItemType Directory | Out-Null }
$artifactName = "M365Documentation-$($newVersion.ToString()).zip"
$artifactPath = Join-Path $DistPath $artifactName

# Copy module to temp and optionally sign
$temp = Join-Path $env:TEMP "M365Documentation_build_$([guid]::NewGuid().ToString())"
Copy-Item -Path $ModulePath -Destination $temp -Recurse -Force

if ($signingEnabled) {
    Write-Host "Signing scripts in temp module copy..."
    $psfiles = Get-ChildItem -Path $temp -Recurse -Include *.ps1,*.psm1
    foreach ($f in $psfiles) {
        try {
            Set-AuthenticodeSignature -Certificate $cert -TimestampServer 'http://timestamp.digicert.com' -FilePath $f.FullName | Out-Null
        } catch {
            Write-Warning "Failed to sign $($f.FullName): $_"
        }
    }
}

# Create zip artifact
if (Test-Path $artifactPath) { Remove-Item $artifactPath -Force }
Compress-Archive -Path (Join-Path $temp '*') -DestinationPath $artifactPath -Force

# Cleanup
Remove-Item -Path $temp -Recurse -Force

Write-Host "Build completed. Artifact: $artifactPath"

# Finish
exit 0
