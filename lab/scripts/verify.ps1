$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

Write-Host "==> flutter analyze"
flutter analyze

Write-Host "==> flutter test"
flutter test

Write-Host "Verify done."
