# Dev Coding Skills

A structured AI-assisted development workflow library for Claude Code. Enforces disciplined information gathering and planning before writing any code.

---

## Overview

This repository contains three independent command-driven skills that form a complete development lifecycle:

| Command | Purpose | Trigger |
|---------|---------|---------|
| `/fix-plan` | Structured bug investigation & debugging | When fixing bugs, crashes, or errors |
| `/dev-plan` | Development planning before coding | When building new features |
| `/dev-change` | Automated changelog generation | When a task is completed |

**Core Principle:** No code is written until information is fully collected, plans are confirmed, and acceptance criteria are defined.

---

## Why This Exists

Most AI coding assistants jump straight to writing code based on vague descriptions. This leads to:

- Wrong assumptions and wasted effort
- Fixes that don't address the root cause
- Missing edge cases and compatibility issues
- Undocumented changes that are hard to trace later

These skills enforce a structured workflow:

```
[Bug Report]      ── /fix-plan ──→  Interview → Evidence → Analysis → Fix
[Feature Request] ── /dev-plan ──→  Interview → Plan → Acceptance → Code
[Task Done]       ── /dev-change ─→ Auto-generated CHANGELOG
```

---

## How It Works

### `/fix-plan` — Debug Interview (7 Phases)

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

**Constraint:** Maximum 2-3 questions per turn. No skipping stages.

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

---

## Installation

Copy the desired skill directories into your Claude Code skills folder. Install only what you need, or all three:

```bash
# Global skills
~/.claude/skills/

# Or project-level
./.claude/skills/
```

Example — install all three:
```bash
cp -r fix-plan dev-plan dev-change ~/.claude/skills/
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
