# lookup-name.ps1 — Wrapper to run lookup-name.py
param(
    [Parameter(Position=0)]
    [string]$MappingDir,
    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$RemainingArgs,
    [Alias('h')]
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help -or -not $MappingDir) {
    Write-Host @"
Usage: lookup-name.ps1 <mapping-dir> <query>
       lookup-name.ps1 <mapping-dir> -o <obf-fqn>
       lookup-name.ps1 <mapping-dir> -p <real-package-substring>
       lookup-name.ps1 <mapping-dir> --grep <regex> <sources-dir>
"@
    exit 0
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pyScript = Join-Path $scriptDir "lookup-name.py"

$pythonBin = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonBin) {
    $pythonBin = Get-Command python3 -ErrorAction SilentlyContinue
}

if (-not $pythonBin) {
    Write-Host "Error: Python 3 is required to run lookup-name.py" -ForegroundColor Red
    exit 1
}

& $pythonBin $pyScript $MappingDir @RemainingArgs
