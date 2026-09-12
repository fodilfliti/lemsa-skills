$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

Write-Host "==> flutter pub get"
flutter pub get

Write-Host "==> dart run slang"
dart run slang

Write-Host "==> dart run build_runner build --delete-conflicting-outputs"
dart run build_runner build --delete-conflicting-outputs

Write-Host "Codegen done."
