param(
    [Parameter(Mandatory = $true)]
    [string]$PackagePath
)

$ErrorActionPreference = 'Stop'

$resolvedPackagePath = Resolve-Path $PackagePath

$requiredFiles = @(
    'README.md',
    'IMPLEMENTATION_BRIEF.md',
    'contract\01_Overview.md',
    'contract\02_InterfaceContract.md',
    'contract\03_ErrorModel.md',
    'contract\04_AcceptanceCriteria.md',
    'tests\README.md'
)

$missing = @()
foreach ($relativePath in $requiredFiles) {
    $fullPath = Join-Path $resolvedPackagePath $relativePath
    if (-not (Test-Path $fullPath)) {
        $missing += $relativePath
    }
}

if ($missing.Count -gt 0) {
    Write-Error ("Missing required files:`n - " + ($missing -join "`n - "))
    exit 1
}

$unresolvedMatches = @()
$tokenPattern = '\[[A-Za-z][A-Za-z0-9 _\-]*\]'
$ignoredTokens = @(
    '[nodiscard]'
)
Get-ChildItem -Path $resolvedPackagePath -Recurse -File | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern $tokenPattern -AllMatches
    foreach ($match in $matches) {
        foreach ($token in $match.Matches) {
            if ($ignoredTokens -contains $token.Value) {
                continue
            }
            $unresolvedMatches += [PSCustomObject]@{
                Path = $_.FullName
                Line = $match.LineNumber
                Token = $token.Value
            }
        }
    }
}

if ($unresolvedMatches.Count -gt 0) {
    Write-Output 'Unresolved placeholder tokens found:'
    $unresolvedMatches | ForEach-Object {
        Write-Output ("- {0}:{1} {2}" -f $_.Path, $_.Line, $_.Token)
    }
    exit 2
}

Write-Output "Contract package looks structurally valid: $resolvedPackagePath"
