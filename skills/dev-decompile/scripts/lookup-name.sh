#!/usr/bin/env bash
# lookup-name.sh — Query the mapping produced by recover-kotlin-names.py.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: lookup-name.sh <mapping-dir> <query>"
  echo "       lookup-name.sh <mapping-dir> -o <obf-fqn>"
  echo "       lookup-name.sh <mapping-dir> -p <real-package-substring>"
  echo "       lookup-name.sh <mapping-dir> --grep <regex> <sources-dir>"
  exit 0
fi

python3 "$SCRIPT_DIR/lookup-name.py" "$@"
