#!/usr/bin/env python3
"""
lookup-name.py — Query the mapping produced by recover-kotlin-names.py.

Modes:
  lookup-name.py <mapping-dir> <query>
  lookup-name.py <mapping-dir> -o <obf-fqn>
  lookup-name.py <mapping-dir> -p <real-package-substring>
  lookup-name.py <mapping-dir> --grep <regex> <sources-dir>
"""

import json
import os
import re
import sys

def main():
    if len(sys.argv) < 3 or sys.argv[1] in ("-h", "--help"):
        print("Usage: lookup-name.py <mapping-dir> <query>")
        print("       lookup-name.py <mapping-dir> -o <obf-fqn>")
        print("       lookup-name.py <mapping-dir> -p <real-package-substring>")
        print("       lookup-name.py <mapping-dir> --grep <regex> <sources-dir>")
        sys.exit(0)

    mapping_dir = sys.argv[1]
    args = sys.argv[2:]
    map_path = os.path.join(mapping_dir, "mapping.json")

    if not os.path.isfile(map_path):
        print(f"Error: no mapping.json found in {mapping_dir}", file=sys.stderr)
        sys.exit(1)

    with open(map_path, "r", encoding="utf-8") as f:
        mapping = json.load(f)

    rev = {}
    for o, r in mapping.items():
        rev.setdefault(r, []).append(o)

    def search(q):
        ql = q.lower()
        found = False
        for r in sorted(rev):
            if ql in r.lower():
                found = True
                print(r)
                for o in sorted(rev[r]):
                    print(f"    {o}")
        if not found:
            print(f"No match found for '{q}'")

    def by_obf(o):
        if o not in mapping:
            print(f"No mapping for {o}", file=sys.stderr)
            sys.exit(1)
        print(f"{o}  ->  {mapping[o]}")
        sibs = [s for s in rev.get(mapping[o], []) if s != o]
        for s in sorted(sibs):
            print(f"    sibling: {s}")

    def by_pkg(p):
        pl = p.lower()
        found = False
        for r in sorted(rev):
            if pl in r.rsplit(".", 1)[0].lower():
                found = True
                print(r)
                for o in sorted(rev[r]):
                    print(f"    {o}")
        if not found:
            print(f"No classes found for package substring '{p}'")

    def grep_annot(pattern, sources):
        regex = re.compile(pattern)
        for dp, _, files in os.walk(sources):
            for f in files:
                if not (f.endswith(".java") or f.endswith(".kt")):
                    continue
                path = os.path.join(dp, f)
                rel = os.path.relpath(path, sources)
                ext_len = 5 if f.endswith(".java") else 3
                obf = rel[:-ext_len].replace(os.sep, ".")
                try:
                    with open(path, "r", encoding="utf-8", errors="replace") as fh:
                        for lineno, line in enumerate(fh, start=1):
                            if regex.search(line):
                                line_clean = line.rstrip("\r\n")
                                suffix = f"  // {mapping[obf]}" if obf in mapping else ""
                                print(f"{rel}:{lineno}:{line_clean}{suffix}")
                except OSError:
                    continue

    if args[0] == "-o" and len(args) == 2:
        by_obf(args[1])
    elif args[0] == "-p" and len(args) == 2:
        by_pkg(args[1])
    elif args[0] == "--grep" and len(args) == 3:
        grep_annot(args[1], args[2])
    else:
        search(" ".join(args))

if __name__ == "__main__":
    main()
