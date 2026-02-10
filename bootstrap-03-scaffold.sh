#!/usr/bin/env bash
# =============================================================================
# bootstrap-03-scaffold.sh
# =============================================================================
#
# PHASE 3 PURPOSE
# ---------------
# Phase 3 creates the *actual course repository scaffolding*:
#   - README.md / AGENTS.md / MEMORY.md / PLAN.md
#   - directory structure: lessons/, docs/, projects/, .codex/
#   - Codex prompt templates (to avoid needing ChatGPT chat)
#   - lesson skeletons (placeholders Codex will expand)
#
# This script is based on the earlier "single-phase bootstrap" design you used
# as Phase-3 reference. (See uploaded bootstrap.sh content) 1
#
# REQUIRED ORDER (two-phase bootstrap workflow)
# ---------------------------------------------
# 1) Run bootstrap-01-local.sh
#    -> Creates .git and first commit containing the bootstrap scripts.
#
# 2) Run bootstrap-02-remote.sh (optional but typical)
#    -> Adds origin remote and pushes.
#
# 3) Run THIS script bootstrap-03-scaffold.sh
#    -> Populates the repo with the course scaffolding and lesson skeletons.
#
# Why split it this way?
# - Phase 1+2 are about Git and publishing.
# - Phase 3 is about building the *learning content architecture*.
# - This separation makes the repo reproducible and beginner-friendly.
#
# IMPORTANT COURSE REQUIREMENTS (baked into generated files)
# ----------------------------------------------------------
# - Codex-only authoring: AGENTS.md + .codex prompts define the workflow.
# - No GitHub Copilot instruction files.
# - No prior knowledge assumed for Python/C/C++ (crash lessons included).
# - One dedicated VS Code environment lesson included.
# - Extended plan includes:
#     * Nonvolatile storage (EEPROM equivalent on RP chips)
#     * Temperature/Humidity/Pressure sensor lesson (I2C)
#     * Button matrix scanning (local keyboard)
#
# SAFETY / IDEMPOTENCE
# --------------------
# This script tries very hard NOT to destroy your work.
# By default it will:
# - Create files only if missing
# - Create directories if missing
#
# If you want to overwrite existing files (rare), you can run with:
#   FORCE=1 bash bootstrap-03-scaffold.sh
#
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration switches
# -----------------------------------------------------------------------------
FORCE="${FORCE:-0}"   # set to 1 to overwrite existing files

# -----------------------------------------------------------------------------
# Helper functions: safe file creation
# -----------------------------------------------------------------------------
# write_file <path> <heredoc>
# - If FORCE=1: overwrite
# - Else: create only if missing
write_file() {
  local path="$1"
  if [[ -f "$path" && "$FORCE" != "1" ]]; then
    echo "SKIP (exists): $path"
    return 0
  fi

  # Ensure parent directory exists
  mkdir -p "$(dirname "$path")"

  # Read stdin into file
  cat > "$path"
  echo "WRITE: $path"
}

# mkdir_safe <dir>
mkdir_safe() {
  mkdir -p "$1"
}

# -----------------------------------------------------------------------------
# Safety checks
# -----------------------------------------------------------------------------
CURRENT_DIR="$(pwd)"
if [[ "$CURRENT_DIR" == "/" || "$CURRENT_DIR" == "$HOME" ]]; then
  echo "Refusing to run in '$CURRENT_DIR' (too dangerous)."
  exit 1
fi

# Phase 3 MUST run inside an already-initialized git repo (created in Phase 1).
if [[ ! -d ".git" ]]; then
  echo "ERROR: .git not found."
  echo "Run Phase 1 first (bootstrap-01-local.sh), then run this script."
  exit 1
fi

# Ensure we actually have commits; otherwise the learner may be confused later.
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "ERROR: git repo exists but has no commits."
  echo "Run Phase 1 again (or create an initial commit) before Phase 3."
  exit 1
fi

# -----------------------------------------------------------------------------
# 1) Directory structure (matches the earlier single-phase script design)
# -----------------------------------------------------------------------------
# We keep authoring sources in /lessons, and published pages in /docs.
# /projects contains longer experiments (MicroPython + Pico SDK).
# /.codex contains Codex prompt templates so the repo is self-authoring.
mkdir_safe lessons
mkdir_safe projects/micropython
mkdir_safe projects/pico-sdk
mkdir_safe docs
mkdir_safe docs/lessons
mkdir_safe docs/authoring
mkdir_safe .codex/prompts

# -----------------------------------------------------------------------------
# 2) README.md
# -----------------------------------------------------------------------------
write_file "README.md" <<'MD'
# RP2040 / RP2350 (Pico / Pico 2) — Self-Study Course

This repository is a complete self-study course that you can build and follow
locally using **VS Code + the Codex extension**.

## Key principles
- Lessons are **90 minutes** each.
- Every lesson ends with an **assessment** (quiz + practical task + rubric).
- The course assumes **no prior knowledge** of:
  - Python
  - C
  - C++
- The course is authored and maintained **using Codex only**
  (no GitHub Copilot instructions, and ideally no ChatGPT chat needed).

## Where things live
- `PLAN.md`        — course roadmap / checklist
- `MEMORY.md`      — project memory (decisions, conventions, open questions)
- `AGENTS.md`      — instructions for Codex (how to work inside this repo)
- `lessons/`       — lesson sources (overview + assessment + code)
- `docs/`          — published course pages (GitHub Pages-friendly)
- `projects/`      — longer-running code projects (MicroPython + Pico SDK)
- `.codex/`        — Codex configuration + reusable prompts/templates

## Publishing
GitHub Pages can serve `/docs` directly (Settings → Pages → main → /docs).
MD

# -----------------------------------------------------------------------------
# 3) MEMORY.md (project memory)
# -----------------------------------------------------------------------------
# This is where Codex records evolving decisions so you don’t need ChatGPT chat
# for continuity. It’s the “in-repo long-term memory.”
write_file "MEMORY.md" <<'MD'
# Project Memory (RP Pico Self-Study)

This file is the long-term memory of the repository.
Codex should keep it updated when decisions are made.

## Fixed decisions
- Lessons are 90 minutes and always include an assessment.
- Course assumes no prior knowledge of Python/C/C++.
- Authoring workflow uses VS Code + Codex only.
- Lesson structure is standardized (see AGENTS.md).
- Phase bootstrap approach:
  - Phase 1: local repo init + first commit contains bootstrap scripts
  - Phase 2: add remote + push
  - Phase 3: scaffold course structure (this file set)

## Hardware assumptions (update when confirmed)
- Target boards:
  - Raspberry Pi Pico (RP2040)
  - Raspberry Pi Pico 2 (RP2350)
- Always state explicitly when a step is Pico-only vs Pico-2-only.
- Record any pin mappings used by lessons here.

## Nonvolatile storage policy
- RP2040/RP2350 do not have "classic AVR EEPROM" built-in.
- Use one of:
  - Flash-based key/value storage (with wear considerations)
  - File system on flash (LittleFS or similar) if available in the chosen runtime
- If we adopt a specific approach in lessons, record it here.

## Open questions / to verify (keep short)
- LED pin conventions for Pico vs Pico 2 in MicroPython + SDK.
- Recommended THP sensor model for lessons (e.g., BME280/BMP280/SHT31 combo).
- Recommended keypad matrix size for the button-matrix lesson.

## Status log (append, don’t overwrite)
- YYYY-MM-DD: Phase 3 scaffold created.
MD

# -----------------------------------------------------------------------------
# 4) AGENTS.md (Codex-only workflow constitution)
# -----------------------------------------------------------------------------
write_file "AGENTS.md" <<'MD'
# AGENTS.md — Codex Agent Instructions

## Mission
Build and maintain a complete self-study course for Raspberry Pi Pico (RP2040)
and Pico 2 (RP2350). The repo must remain consistent and runnable.

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
- Published copies of lessons go to `/docs/lessons/`.
- Keep published pages short and navigable.

## Memory discipline
- Update MEMORY.md when:
  - making decisions (naming, structure, toolchain)
  - discovering Pico vs Pico 2 differences
  - adding new “course conventions” (storage approach, sensor choice, etc.)

## Quality gates
Before considering a lesson done:
- It has overview + assessment + code.
- Code runs/builds (as applicable).
- Assessment includes rubric (and preferably answers/hints).
MD

# -----------------------------------------------------------------------------
# 5) PLAN.md (extended per your new requirements)
# -----------------------------------------------------------------------------
# We avoid renumbering existing lesson IDs. Instead, we add suffix lessons:
# - L04A: Nonvolatile storage (EEPROM equivalent)
# - L05A: THP sensor (temp/humidity/pressure) via I2C
# - L05B: Button matrix scanning (local keyboard)
#
# This preserves the earlier numbering and keeps diffs simple.
write_file "PLAN.md" <<'MD'
# RP2040 / RP2350 Pico Self-Study Course Plan (90-minute lessons)

Legend: ☐ not started · ☐ in progress · ☑ done

## Standard lesson timing (90 minutes)
- 10 min: orientation (goals, setup, expected outcome)
- 55 min: guided build (steps + checkpoints)
- 10 min: concept reflection (“explain it back”)
- 15 min: assessment (quiz + practical task + rubric)

---

## Module 0 — Development environment and language crash courses (no prior knowledge)

☐ L00 VS Code development environment (for this course)
   - Install VS Code
   - Install required extensions
   - Serial monitor workflow (USB CDC / UART adapter options)
   - Pico SDK build workflow (CMake + toolchain)
   - MicroPython upload workflow
   - Codex workflow inside the repo:
     - how to use AGENTS.md
     - how to use .codex/prompts
     - how to update MEMORY.md + PLAN.md

☐ L0A Python crash course (for MicroPython + tooling)
   - variables, types, functions
   - conditionals, loops
   - modules, files
   - minimal debugging habits

☐ L0B C crash course (for embedded SDK code)
   - compilation model, headers, functions
   - pointers (intro), arrays, structs
   - memory model mental picture (stack vs static vs heap)

☐ L0C C++ crash course (minimal for Pico SDK)
   - what changes vs C
   - references vs pointers (conceptual)
   - constructors/destructors idea (conceptual)
   - “use C first, C++ later” rule of thumb

---

## Module 1 — Pico foundations (MicroPython + Pico SDK)

☐ L01 Setup & flashing (MicroPython + Pico SDK “hello world”)
☐ L02 GPIO output + input + pull-ups + debouncing
☐ L03 Timing: delays vs timers + PWM basics
☐ L04 UART logging + simple command console

☐ L04A Nonvolatile storage (EEPROM equivalent on RP2040/RP2350)
   - Why there is no classic EEPROM (typical on AVR) and what exists instead
   - Flash basics: erase blocks, write granularity, wear considerations
   - Safe patterns:
     - small config struct with version + checksum
     - append-only log + compaction
   - MicroPython option: file-based config (if filesystem available)
   - Pico SDK option: flash programming API + simple KV store
   - Assessment: store and retrieve a calibration/config value across reboot

---

## Module 2 — Communication and real devices

☐ L05 I2C basics + error handling
   - scanning the bus
   - addressing
   - retry strategy and timeouts

☐ L05A Temperature/Humidity/Pressure sensor (THP) via I2C
   - choose a common module (e.g., BME280-class) and read:
     temperature, humidity, pressure
   - data conversion and units
   - basic filtering (moving average)
   - output to serial console in a stable format
   - Assessment: implement “sensor health” checks (range validation + retry)

☐ L05B Button matrix scanning (local keyboard)
   - row/column wiring and why diodes may be needed (ghosting)
   - scanning loop and debouncing strategy
   - mapping matrix coordinates to key codes
   - output pressed keys to serial
   - Assessment: implement N-key rollover behavior limits and document them

☐ L06 SPI throughput + display/ADC (choose 1 device)
☐ L07 Interrupts: GPIO + timer + safe shared state

---

## Module 3 — RP “superpowers”

☐ L08 PIO intro: waveform generator
☐ L09 PIO: custom protocol (choose a target)
☐ L10 DMA: continuous sampling into ring buffer

---

## Module 4 — Architecture & product skills

☐ L11 Dual-core patterns: queues, producer/consumer
☐ L12 Low power modes: compare Pico vs Pico 2
☐ L13 USB device: CDC serial
☐ L14 USB HID device (keyboard or mouse)
   - (This can optionally reuse the button matrix from L05B)

---

## Capstone (2 lessons)

☐ L15 Capstone build (choose one final project)
☐ L16 Capstone polish: docs, tests, release tag

---

## Deliverables per lesson
- /lessons/Lxx-*/overview.md
- /lessons/Lxx-*/assessment.md
- /lessons/Lxx-*/code/ (working examples)
- /docs/lessons/Lxx-*.md (published version)
MD

# -----------------------------------------------------------------------------
# 6) Codex prompt templates (so the repo “authors itself”)
# -----------------------------------------------------------------------------
write_file ".codex/prompts/lesson-generator.md" <<'MD'
# Codex Prompt Template: Generate a Lesson

You are working inside this repo. Follow AGENTS.md strictly.

Task:
- Create a new lesson directory under /lessons named:
  /lessons/<LESSON_ID>-<short-slug>/

Inside it create:
- overview.md (90-minute structure, checklists, expected results)
- assessment.md (quiz + practical task + rubric)
- code/ directory with minimal runnable examples

Also create a published page:
- /docs/lessons/<LESSON_ID>-<short-slug>.md
  (a compact learner-facing version)

Update:
- PLAN.md: mark the lesson as ☐ in progress (or ☑ done if fully complete)
- MEMORY.md: record any decisions or discovered pitfalls
MD

write_file ".codex/prompts/consistency-check.md" <<'MD'
# Codex Prompt Template: Consistency Check

Follow AGENTS.md strictly.

Task:
- Scan the repository for consistency:
  - Every lesson has overview.md and assessment.md
  - Published docs exist for each lesson
  - PLAN.md matches existing lessons
  - MEMORY.md has no contradictions

Output:
- A short report in Markdown
- A list of proposed fixes (do not apply unless asked)
MD

# -----------------------------------------------------------------------------
# 7) docs/ (published site skeleton)
# -----------------------------------------------------------------------------
write_file "docs/index.md" <<'MD'
# RP2040 / RP2350 Pico Course

This is the published version of the course.

Start here:
- [Syllabus](syllabus.md)

Authoring sources live in `/lessons/`.
MD

write_file "docs/syllabus.md" <<'MD'
# Syllabus

This page mirrors PLAN.md and links to published lessons as they appear.

Lessons appear under:
- `/docs/lessons/`
MD

# -----------------------------------------------------------------------------
# 8) Lesson skeleton generator (placeholders Codex will expand)
# -----------------------------------------------------------------------------
create_lesson_skeleton () {
  local id="$1"
  local slug="$2"
  local title="$3"

  local dir="lessons/${id}-${slug}"
  mkdir -p "${dir}/code"

  # overview.md
  write_file "${dir}/overview.md" <<MD
# ${id} — ${title} (90 minutes)

## Outcome (what you will have at the end)
- TODO (Codex: fill)

## Prerequisites
- None (assume beginner)

## 90-minute plan
### 0–10 min: Orientation
- TODO

### 10–65 min: Guided build
- TODO (checkpoints)

### 65–75 min: Explain it back
- TODO (concept questions)

### 75–90 min: Assessment
- Go to: assessment.md
MD

  # assessment.md
  write_file "${dir}/assessment.md" <<MD
# ${id} — Assessment

## Quiz (self-check)
1. TODO
2. TODO
3. TODO

## Practical task
- TODO (a concrete task)

## Rubric (how to grade yourself)
- Pass if:
  - TODO
MD

  # published page placeholder
  write_file "docs/lessons/${id}-${slug}.md" <<MD
# ${id} — ${title}

> Published version. Source is in \`/lessons/${id}-${slug}/\`.

TODO: This lesson will be expanded by Codex.
MD
}

# Early module skeletons (as in your original scaffold)
create_lesson_skeleton "L00" "vscode-env" "VS Code Development Environment"
create_lesson_skeleton "L0A" "python-crash" "Python Crash Course (for MicroPython + tooling)"
create_lesson_skeleton "L0B" "c-crash" "C Crash Course (for embedded work)"
create_lesson_skeleton "L0C" "cpp-crash" "C++ Crash Course (minimal for Pico SDK)"
create_lesson_skeleton "L01" "setup-flash" "Setup & Flashing (MicroPython + Pico SDK)"

# New requirement skeletons:
create_lesson_skeleton "L04A" "nonvolatile-storage" "Nonvolatile Storage (EEPROM equivalent)"
create_lesson_skeleton "L05A" "thp-sensor" "Temperature/Humidity/Pressure Sensor (I2C)"
create_lesson_skeleton "L05B" "button-matrix" "Button Matrix Scanning (Local Keyboard)"

# -----------------------------------------------------------------------------
# 9) Commit changes (Phase 3 should create a clean commit)
# -----------------------------------------------------------------------------
git add .

if git diff --cached --quiet; then
  echo "No changes staged; nothing to commit."
else
  git commit -m "Phase 3: scaffold Codex-only course + extend plan (storage, THP sensor, button matrix)"
fi

# -----------------------------------------------------------------------------
# 10) Final guidance for Codex-only workflow
# -----------------------------------------------------------------------------
cat <<'TXT'

Phase 3 complete.

Recommended next steps (Codex-only workflow):
1) Open this folder in VS Code.
2) Use Codex agent mode and follow AGENTS.md.
3) Start with L00 and fully implement it (overview + assessment + runnable steps).
4) Use .codex/prompts/lesson-generator.md as your standard prompt template.
5) Keep MEMORY.md updated when hardware/toolchain decisions are made.

Notes:
- This script does not touch remotes and does not push.
- Push whenever you want using normal git commands.

TXT