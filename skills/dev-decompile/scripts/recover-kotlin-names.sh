#!/usr/bin/env bash
# recover-kotlin-names.sh — Rebuild a (obfuscated -> real) class-name map
# from Kotlin metadata strings left in decompiled sources.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: recover-kotlin-names.sh <decompiled-sources-dir> [output-dir]"
  exit 0
fi

python3 "$SCRIPT_DIR/recover-kotlin-names.py" "$@"
