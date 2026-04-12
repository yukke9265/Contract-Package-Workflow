param(
    [Parameter(Mandatory = $true)]
    [string]$Preset,

    [switch]$Configure,
    [switch]$Build,
    [switch]$Test,

    [ValidateSet('x64', 'x86', 'amd64')]
    [string]$Arch = 'x64',

    [ValidateSet('x64', 'x86', 'amd64')]
    [string]$HostArch = 'x64'
)

$ErrorActionPreference = 'Stop'

if (-not ($Configure -or $Build -or $Test)) {
    $Configure = $true
    $Build = $true
}

. (Join-Path $PSScriptRoot 'Initialize-VsCMakeEnv.ps1') -Arch $Arch -HostArch $HostArch

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Set-Location $repoRoot

if ($Configure -or $Build -or $Test) {
    cmake --preset $Preset
    if ($LASTEXITCODE -ne 0) {
        throw "Configure failed for preset: $Preset"
    }
}

$buildDir = Join-Path $repoRoot (Join-Path 'out\build' $Preset)
$configName = if ($Preset -match 'release') { 'Release' } else { 'Debug' }

if ($Build) {
    cmake --build $buildDir --config $configName
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed for preset: $Preset"
    }
}

if ($Test) {
    ctest --test-dir $buildDir --output-on-failure -C $configName
    if ($LASTEXITCODE -ne 0) {
        throw "Tests failed for preset: $Preset"
    }
}