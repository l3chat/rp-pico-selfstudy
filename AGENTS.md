# AGENTS.md — Codex Agent Instructions

## Mission
Build and maintain a complete self-study course for Raspberry Pi Pico (RP2040)
and Pico 2 (RP2350), plus RP2040-Zero and RP2350-Zero dev boards.
The repo must remain consistent and runnable.

## Core constraints (do not violate)
1) **Codex-only workflow**
   - Assume the user will primarily use VS Code + Codex.
   - Do not rely on GitHub Copilot instructions.
   - Do not require ChatGPT chat to follow the course.

2) **Lesson format**
   - Every lesson is designed for **90 minutes** total.
   - Every lesson ends with an **assessment**:
     - short quiz
     - practical task
     - rubric (how to self-grade)

3) **Beginner language assumptions**
   - Assume zero prior knowledge of Python, C, C++.
   - Early lessons include crash courses for these languages.

4) **No invented hardware facts**
   - If any hardware detail is uncertain (pin mapping, LED pin, voltage),
     mark it as a TODO and record it in MEMORY.md.

## Session-start baseline scan (required)
- On the first turn of each new Codex session:
  - Read `AGENTS.md`, `PLAN.md`, `MEMORY.md`, `TODO.md`, and user-mentioned files.
  - Run `git status --short`.
  - Run `rg --files` (or targeted `find`) to map the current structure.
  - Confirm scope before editing.
- Keep this scan lightweight (not a deep full-repo audit each follow-up turn).
- Re-scan deeply only when scope changes, many files are touched, or git state changes.

## Task tracking discipline
- Use root `TODO.md` as the task tracker.
- Keep active items under `## todos`.
- Move finished items to `## done`.

## Mandatory lesson structure
Each lesson directory in `/lessons/` must contain:
- `overview.md`
- `assessment.md`
- `code/` (runnable minimal examples)
Optionally:
- `notes.md` (extra references, pitfalls, troubleshooting)

## Writing style requirements
- Step-by-step instructions
- Checklists
- Explicit expected observable results
- Troubleshooting: “If you see X, do Y”

## Publishing requirements
- `lessons/` is the source of truth; do not maintain duplicated lesson text in `docs/`.
- Generated site output comes from `scripts/build_site.py`.
- GitHub Pages deployment is done via `.github/workflows/deploy-pages.yml`.
- Keep generated pages navigable.

## Memory discipline
- Update MEMORY.md when:
  - making decisions (naming, structure, toolchain)
  - discovering differences across supported boards
    (Pico / Pico 2 / RP2040-Zero / RP2350-Zero)
  - adding new “course conventions” (storage approach, sensor choice, etc.)

## Quality gates
Before considering a lesson done:
- It has overview + assessment + code.
- Code runs/builds (as applicable).
- Assessment includes rubric (and preferably answers/hints).
- Site build script still runs after your changes.
