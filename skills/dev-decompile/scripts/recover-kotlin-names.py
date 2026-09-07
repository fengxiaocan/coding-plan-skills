#!/usr/bin/env python3
"""
recover-kotlin-names.py — Rebuild a (obfuscated -> real) class-name map
from Kotlin metadata strings left in decompiled sources.

R8 obfuscates JVM symbols but cannot strip Kotlin metadata strings.
Two annotations carry original FQNs:
  * @DebugMetadata(c = "<full.qualified.Name>", ...)
  * @Metadata(... d2 = {"...L<pkg/Class>;..."} ...)
"""

import os
import re
import sys
import json
from collections import defaultdict

def main():
    if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
        print("Usage: recover-kotlin-names.py <decompiled-sources-dir> [output-dir]")
        sys.exit(0)

    src = os.path.abspath(sys.argv[1])
    out = os.path.abspath(sys.argv[2]) if len(sys.argv) > 2 else os.path.join(os.path.dirname(src), "mapping")

    if not os.path.isdir(src):
        print(f"Error: Not a directory: {src}", file=sys.stderr)
        sys.exit(1)

    os.makedirs(os.path.join(out, "by_package"), exist_ok=True)

    re_debug = re.compile(r'@DebugMetadata\([^)]*?c\s*=\s*"([^"]+)"', re.S)
    re_dtwo = re.compile(r'@Metadata\([^)]*?d2\s*=\s*\{([^}]*)\}', re.S)
    re_lclass = re.compile(r'L([A-Za-z][\w/$]+);')
    re_renamed = re.compile(r'/\*\s*renamed from:\s*([\w.$]+)\s*\*/')

    skip_prefixes = (
        "kotlin.", "kotlinx.", "androidx.", "android.", "java.", "javax.",
        "com.google.", "com.facebook.", "com.appsflyer.", "com.datadog.",
        "io.ktor.", "io.sentry.", "io.realm.", "okhttp3.", "okio.",
        "com.squareup.", "com.bumptech.", "com.airbnb.", "com.payu.",
        "com.storyteller.", "zendesk.", "io.intercom.", "com.microsoft.",
        "com.tinder.", "com.hotjar.", "com.amplitude.", "com.segment.",
        "com.mixpanel.", "com.onesignal.", "com.stripe.", "com.braintreepayments.",
        "retrofit2.", "dagger.", "javax.inject.", "org.jetbrains.",
    )

    mapping = {}
    file_real = {}
    counts = defaultdict(int)

    for dp, _, files in os.walk(src):
        for f in files:
            if not f.endswith(".java") and not f.endswith(".kt"):
                continue
            path = os.path.join(dp, f)
            rel = os.path.relpath(path, src)
            ext_len = 5 if f.endswith(".java") else 3
            obf = rel[:-ext_len].replace(os.sep, "/")
            obf_dotted = obf.replace("/", ".")
            if obf_dotted.startswith(skip_prefixes):
                continue
            try:
                with open(path, "r", encoding="utf-8", errors="replace") as fh:
                    text = fh.read()
            except OSError:
                continue

            real = None

            m = re_debug.search(text)
            if m:
                real = m.group(1).split("$", 1)[0]
                counts["debug_meta"] += 1

            if not real:
                m = re_dtwo.search(text)
                if m:
                    for lm in re_lclass.finditer(m.group(1)):
                        cand = lm.group(1).replace("/", ".").split("$", 1)[0]
                        if "." in cand and not cand.startswith(("kotlin.", "java.", "android")):
                            real = cand
                            counts["d2"] += 1
                            break

            if not real:
                m = re_renamed.search(text)
                if m:
                    real = m.group(1)
                    counts["renamed"] += 1

            if real:
                mapping[obf_dotted] = real
                file_real[obf_dotted] = path

    with open(os.path.join(out, "mapping.tsv"), "w", encoding="utf-8") as f:
        f.write("obf_fqn\treal_fqn\tfile\n")
        for k in sorted(mapping):
            f.write(f"{k}\t{mapping[k]}\t{file_real[k]}\n")

    with open(os.path.join(out, "mapping.json"), "w", encoding="utf-8") as f:
        json.dump(mapping, f, indent=2, sort_keys=True)

    by_pkg = defaultdict(list)
    for obf, real in mapping.items():
        pkg = real.rsplit(".", 1)[0] if "." in real else "(default)"
        by_pkg[pkg].append((real, obf, file_real[obf]))

    for pkg, rows in by_pkg.items():
        safe = os.path.basename(pkg).replace(".", "_") or "default"
        with open(os.path.join(out, "by_package", f"{safe}.txt"), "w", encoding="utf-8") as f:
            for real, obf, p in sorted(rows):
                f.write(f"{real}\t{obf}\t{p}\n")

    print(f"Recovered {len(mapping)} class names")
    for k, v in counts.items():
        print(f"  via {k}: {v}")
    print(f"Real packages: {len(by_pkg)}")
    print(f"Wrote {out}/mapping.tsv, mapping.json, by_package/")

if __name__ == "__main__":
    main()
