# recover-kotlin-names.ps1 — Wrapper to run recover-kotlin-names.py
param(
    [Parameter(Position=0)]
    [string]$SourceDir,
    [Parameter(Position=1)]
    [string]$OutputDir,
    [Alias('h')]
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help -or -not $SourceDir) {
    Write-Host "Usage: recover-kotlin-names.ps1 <source-dir> [output-dir]"
    exit 0
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pyScript = Join-Path $scriptDir "recover-kotlin-names.py"

$pythonBin = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonBin) {
    $pythonBin = Get-Command python3 -ErrorAction SilentlyContinue
}

if (-not $pythonBin) {
    Write-Host "Error: Python 3 is required to run recover-kotlin-names.py" -ForegroundColor Red
    exit 1
}

if ($OutputDir) {
    & $pythonBin $pyScript $SourceDir $OutputDir
} else {
    & $pythonBin $pyScript $SourceDir
}
