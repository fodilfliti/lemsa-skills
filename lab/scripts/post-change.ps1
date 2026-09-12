$ErrorActionPreference = "Stop"
$Dir = $PSScriptRoot

& (Join-Path $Dir "codegen.ps1")
& (Join-Path $Dir "verify.ps1")
