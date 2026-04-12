param(
    [ValidateSet('x64', 'x86', 'amd64')]
    [string]$Arch = 'x64',

    [ValidateSet('x64', 'x86', 'amd64')]
    [string]$HostArch = 'x64'
)

$ErrorActionPreference = 'Stop'

$vswherePath = 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe'
$devShellModulePath = 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
$ninjaPath = 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja'
$cmakePath = 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin'

if (-not (Test-Path $vswherePath)) {
    throw "vswhere.exe not found: $vswherePath"
}

if (-not (Test-Path $devShellModulePath)) {
    throw "Developer shell module not found: $devShellModulePath"
}

$instance = & $vswherePath -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -format json | ConvertFrom-Json
if (-not $instance) {
    throw 'No Visual Studio installation with C++ tools was found.'
}

Import-Module $devShellModulePath -Force

$devShellArch = if ($Arch -eq 'x64') { 'amd64' } else { $Arch }
$devShellHostArch = if ($HostArch -eq 'x64') { 'amd64' } else { $HostArch }

Enter-VsDevShell -VsInstanceId $instance.instanceId -Arch $devShellArch -HostArch $devShellHostArch -SkipAutomaticLocation | Out-Null

$env:Path = "$ninjaPath;$cmakePath;$env:Path"

Write-Output "Initialized Visual Studio CMake environment for Arch=$Arch HostArch=$HostArch"
Write-Output "cl: $((Get-Command cl.exe).Source)"
Write-Output "cmake: $((Get-Command cmake.exe).Source)"
Write-Output "ninja: $((Get-Command ninja.exe).Source)"