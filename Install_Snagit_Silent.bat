@echo off
setlocal enableextensions

REM === Config ===
set "PKGDIR=%~dp0"
set "MSI=%PKGDIR%snagit.msi"
set "MST=%PKGDIR%snagit-modified1.mst"

REM === Install Snagit silently with MST ===
msiexec.exe /i "%MSI%" TRANSFORMS="%MST%" /qn /norestart
if errorlevel 1 exit /b %errorlevel%

REM === Disable auto-updates via registry ===
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$root='HKLM:\SOFTWARE\TechSmith\SnagIt';" ^
  "if (Test-Path $root) {" ^
  "  Get-ChildItem $root -Name | ForEach-Object {" ^
  "    New-ItemProperty -Path (Join-Path $root $_) -Name 'NoAutoUpdateSupport' -PropertyType DWord -Value 1 -Force | Out-Null" ^
  "  }" ^
  "}"

exit /b 0
