param(
    [Parameter(Mandatory = $true)]
    [string]$PackageName,

    [Parameter(Mandatory = $true)]
    [string]$InterfaceName,

    [Parameter(Mandatory = $true)]
    [string]$ModuleName,

    [Parameter(Mandatory = $true)]
    [string]$PublicHeader,

    [Parameter(Mandatory = $true)]
    [string]$ImplementationFile,

    [Parameter(Mandatory = $true)]
    [string]$StatusType,

    [string]$LanguageVersion = 'C++20',
    [string]$CompilerVersion = 'MSVC 19.3x or later',
    [string]$ExceptionPolicy = 'public API does not throw',
    [string]$ThreadSafety = 'single instance is not thread-safe',
    [string]$OutputRoot = '.'
)

$ErrorActionPreference = 'Stop'

function New-PackageReadmeContent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageName,

        [Parameter(Mandatory = $true)]
        [string]$InterfaceName,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$PublicHeader,

        [Parameter(Mandatory = $true)]
        [string]$ImplementationFile,

        [Parameter(Mandatory = $true)]
        [string]$StatusType
    )

    $templatePath = Join-Path $PSScriptRoot 'templates\PackageReadme.ja.template.md'
    if (-not (Test-Path $templatePath)) {
        throw "Package README template not found: $templatePath"
    }

    $template = Get-Content -Path $templatePath -Raw -Encoding utf8

    $replacements = [ordered]@{
        '[PackageName]' = $PackageName
        '[InterfaceName]' = $InterfaceName
        '[ModuleName]' = $ModuleName
        '[PublicHeader]' = $PublicHeader
        '[ImplementationFile]' = $ImplementationFile
        '[StatusType]' = $StatusType
    }

    foreach ($pair in $replacements.GetEnumerator()) {
        $template = $template.Replace($pair.Key, $pair.Value)
    }

    return $template
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$templatePath = Join-Path $repoRoot 'ContractPackage_Template'

if (-not (Test-Path $templatePath)) {
    throw "Template not found: $templatePath"
}

$destinationName = "ContractPackage_$PackageName"
$destinationPath = Join-Path (Resolve-Path $OutputRoot) $destinationName

if (Test-Path $destinationPath) {
    throw "Destination already exists: $destinationPath"
}

Copy-Item -Path $templatePath -Destination $destinationPath -Recurse

$replacements = [ordered]@{
    "[InterfaceName]" = $InterfaceName
    "[StatusType]" = $StatusType
    "[PrimaryOperation]" = '/* replace with the primary operation call */'
    "[ResourceType]" = 'target resource'
    "[ModuleName]" = $ModuleName
    "[PublicHeader]" = $PublicHeader
    "[ImplementationFile]" = $ImplementationFile
    "[LanguageVersion]" = $LanguageVersion
    "[CompilerVersion]" = $CompilerVersion
    "[ExceptionPolicy]" = $ExceptionPolicy
    "[ThreadSafety]" = $ThreadSafety
    "[InvalidationRule]" = 'fill in for the target contract'
    "[LifecycleRule]" = 'fill in for the target contract'
    "[InputFormat]" = 'fill in for the target contract'
    "[InputConstraint]" = 'fill in for the target contract'
    "[ObservableValue]" = 'observable result for the caller'
    "[FailureKind1]" = 'primary failure kind 1'
    "[FailureKind2]" = 'primary failure kind 2'
    "[AT-01 description]" = 'normal case'
    "[AT-02 description]" = 'boundary or empty input'
    "[AT-03 description]" = 'contract violation or error case'
    "[TestFixtureSetup]" = '/* prepare fixture */'
    "[ExpectedBehavior]" = '/* replace with observable result */'
    "[ShortName]" = 'ReplaceMe'
}

$files = Get-ChildItem -Path $destinationPath -Recurse -File
foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding utf8
    foreach ($pair in $replacements.GetEnumerator()) {
        $content = $content.Replace($pair.Key, $pair.Value)
    }
    Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding utf8
    Add-Content -Path $file.FullName -Value '' -Encoding utf8
}

$headerTemplate = Join-Path $destinationPath 'include\PublicInterface.h'
Rename-Item -Path $headerTemplate -NewName $PublicHeader

$testTemplate = Join-Path $destinationPath 'tests\acceptance_test.cpp'
$testDestinationName = ($InterfaceName + '_acceptance.cpp')
Rename-Item -Path $testTemplate -NewName $testDestinationName

$packageReadmePath = Join-Path $destinationPath 'README.md'
$packageReadme = New-PackageReadmeContent `
    -PackageName $PackageName `
    -InterfaceName $InterfaceName `
    -ModuleName $ModuleName `
    -PublicHeader $PublicHeader `
    -ImplementationFile $ImplementationFile `
    -StatusType $StatusType
Set-Content -Path $packageReadmePath -Value $packageReadme -Encoding utf8

Write-Output "Created contract package: $destinationPath"
