# Dev Coding Skills

A structured AI-assisted development workflow library for Claude Code. Enforces disciplined information gathering and planning before writing any code.

---

## Overview

This repository contains command-driven skills that form a complete development lifecycle:

| Command | Purpose | Trigger |
|---------|---------|---------|
| `/dev-fix` | Structured bug investigation & debugging | When fixing bugs, crashes, or errors |
| `/dev-plan` | Development planning before coding | When building new features |
| `/dev-unified-ui-design` | Cross-platform unified UI/UX design system & responsive styling | When designing/implementing/refactoring cross-platform UI |
| `/dev-android-unified-design` | Unified Android UI/UX design system & Compose styling | When designing/implementing/refactoring Android UI |
| `/dev-analysis` | Code comprehension & architecture documentation | When understanding or documenting code |
| `/dev-decompile`| APK/library decompilation, API extraction & reverse engineering | When decompiling or reverse engineering Android apps/libraries |
| `/dev-change` | Automated changelog generation | When a task is completed |
| `/dev-commit` | Auto stage, conventional commit & safe push | When committing and pushing changes |

**Core Principle:** No code is written until information is fully collected, plans are confirmed, and acceptance criteria are defined.

---

## Why This Exists

Most AI coding assistants jump straight to writing code based on vague descriptions. This leads to:

- Wrong assumptions and wasted effort
- Fixes that don't address the root cause
- Missing edge cases and compatibility issues
- Fragmented UI with magic numbers and broken layouts
- Undocumented changes that are hard to trace later

These skills enforce a structured workflow:

```
[Bug Report]      ── /dev-fix            ──→  Interview → Evidence → Analysis → Fix
[Feature Request] ── /dev-plan           ──→  Interview → Plan → Acceptance → Code
[Unified UI Design]── /dev-unified-ui-design ─→ Scan Tokens → Architecture → Strict Tokens → Responsive → Review
[Android UI/UX]   ── /dev-android-unified-design ──→  Scan Tokens → Architecture → Strict Tokens → Responsive → Review
[Code Analysis]   ── /dev-analysis       ──→  Read Code → Flow Analysis → Doc
[Decompile]       ── /dev-decompile      ──→  Fingerprint → Multi-engine Decompile → API & Flow Doc
[Task Done]       ── /dev-change         ──→  Auto-generated CHANGELOG
[Commit & Push]   ── /dev-commit         ──→  Stage → Conventional Commit → Safe Push
```

---

## How It Works

### `/dev-fix` — Debug Interview (7 Phases)

Before fixing anything, the AI must:
1. Confirm the problem (expected vs actual behavior)
2. Collect environment details (OS, versions, deployment)
3. Gather reproduction steps
4. Collect evidence (logs, stack traces, config files)
5. Summarize the problem — **wait for user confirmation**
6. Analyze root cause
7. Only then write code

**Constraint:** Maximum 3 questions per turn. No guessing without evidence.

### `/dev-plan` — Development Planning (6 Phases)

Before building anything, the AI must:
1. Interview requirements (background, goals, scope, constraints)
2. Generate a Task Specification — **wait for confirmation**
3. Generate an Implementation Plan — **wait for confirmation**
4. Generate an Acceptance Checklist — **wait for confirmation**
5. Only then write code
6. Deliver a completion report

### `/dev-unified-ui-design` — Cross-Platform Unified UI/UX Design System (5 Phases)

Enforces cross-platform design consistency across Web, Mobile (iOS/Android), Desktop, Flutter, React Native, and Compose Multiplatform:
1. Scan & Inventory: Check existing Design Tokens (`Colors`, `Typography`, `Spacing`, `Radius`, `Size`, `Breakpoints`, `ZIndex`) and foundation components (`Button`, `Card`, `Dialog`, `ListItem`, `TextField`)
2. Audit & Architecture: Establish strict information hierarchy (Header → Core Info Card → Primary Action → Section Groups) and eliminate fragmented, ad-hoc components
3. Strict Implementation: Zero magic numbers; 4/8 grid system; uniform button heights (52/44/36px) with anti-wrap (`nowrap` / `maxLines = 1`); semantic colors & full Dark Mode support
4. Edge Cases & Resilience: Defend against 320px small screens, 150% font scaling, ultrawide displays (max content width 1200~1440px / forms 640~840px), Safe Area, keyboard insets, and shrink priority (Icon → Flex Text → Action)
5. Review Checklist & Delivery: Deliver structured audit across 8 dimensions and verify the 17-point final acceptance checklist

**Core Rule:** UI screens assemble components; Design System decides what components look like.

### `/dev-android-unified-design` — Android Unified UI/UX Design System (5 Phases)

Enforces Google Stitch design language and unified Design System for Android Jetpack Compose / View apps:
1. Scan & Inventory: Check existing Design Tokens (`Color`, `Typography`, `Shape`, `Dimensions`) and shared component library (`AppButton`, `AppCard`, `AppListItem`, `AppDialog`, etc.)
2. Audit & Architecture: Establish clear information hierarchy (Title → Core Info → Primary Action → Secondary Sections) and block ad-hoc custom component creation
3. Strict Implementation: Zero magic numbers; 4dp grid system; 48dp touch targets; uniform button heights (52/48/36dp); no button text wrapping; semantic theme colors
4. Responsiveness & Resilience: Defend against 320dp small screens, 130%~150% system font scaling, large tablets (max content width 600~840dp), and Dark Mode
5. UI Review Checklist: Deliver structured audit across visual consistency, buttons, layout resilience, feedback dialogs, and accessibility

**Core Rule:** UI screens assemble components; Design System decides what components look like.

### `/dev-analysis` — Code Analysis & Documentation (3 Phases)

Before generating documentation, the AI must:
1. Confirm analysis goals, module scope, and target output path
2. Read code to analyze structure, call flow, data flow, and dependencies
3. Generate structured documentation according to template

**Output:** `docs/{module}/README.md`

### `/dev-decompile` — Decompilation & Reverse Engineering (7 Phases)

Structured workflow for decompiling and analyzing Android APK/XAPK/JAR/AAR packages:
1. Target verification & automated dependency check (Java 17+, jadx, vineflower)
2. Triage & framework fingerprinting (Flutter/RN/Native triage, HTTP stacks, obfuscation level)
3. Multi-engine decompilation (`jadx`, `vineflower`, or `both` comparison; automatic XAPK/Split APK handling)
4. Architecture & entry point analysis (AndroidManifest, BuildConfig constant leaks)
5. Kotlin obfuscation recovery (`@DebugMetadata` mining to restore original class names) & call flow tracing
6. API endpoint extraction (Retrofit, OkHttp, Ktor, Apollo, URLs) & security credential auditing
7. Report delivery & documentation archiving

**Output:** `docs/decompile/{app-name}/README.md` & `API_INVENTORY.md`

### `/dev-change` — Change Log (10 Sections)

After task completion, automatically generates:
1. Change summary
2. Requirement source
3. Modified files (add/edit/delete/refactor)
4. Core implementation rationale
5. Key function documentation
6. Configuration changes
7. Impact analysis
8. Verification records
9. Rollback plan
10. Future optimization suggestions

**Output:** `docs/CHANGELOG-YYYY-MM-DD.md`

### `/dev-commit` — Git Commit & Push (5 Phases)

Automatically stages workspace changes, generates conventional commit messages, and pushes safely:
1. Check repository status and current branch
2. Scan for sensitive files and stage changes (`git add`)
3. Generate standard Conventional Commit message (`feat`, `fix`, `docs`, `refactor`, etc.)
4. Commit to local branch (`git commit`)
5. Safely push to remote upstream tracking branch (`git push`)

**Constraint:** No force push (`--force` / `-f` forbidden).

---

## Installation

Copy the desired skill directories into your Claude Code skills folder. Install only what you need, or all skills:

```bash
# Global skills
~/.claude/skills/

# Or project-level
./.claude/skills/
```

Example — install all skills:
```bash
cp -r dev-fix dev-plan dev-unified-ui-design dev-android-unified-design dev-analysis dev-decompile dev-change dev-commit ~/.claude/skills/
```

---

## Design Principles

| Principle | Description |
|-----------|-------------|
| **No premature coding** | Information gathering and planning must be complete first |
| **User confirmation gates** | Each stage requires explicit user approval before proceeding |
| **Evidence-based diagnosis** | No guessing root causes without logs or stack traces |
| **Honest documentation** | Verification results must be factual; failures cannot be omitted |
| **Progressive questioning** | 2-3 questions per turn to avoid overwhelming the user |

---

## License

MIT
