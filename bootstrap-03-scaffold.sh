#!/usr/bin/env bash
# =============================================================================
# bootstrap-03-scaffold.sh
# =============================================================================
#
# PHASE 3 PURPOSE
# ---------------
# Phase 3 creates the *actual course repository scaffolding*:
#   - README.md / AGENTS.md / MEMORY.md / PLAN.md / TODO.md
#   - directory structure: lessons/, projects/, scripts/, .github/, .codex/
#   - Codex prompt templates (to avoid needing ChatGPT chat)
#   - lesson skeletons (placeholders Codex will expand)
#   - GitHub Actions publishing pipeline (no duplicated docs tree in git)
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
# If you want to start from scratch, run with:
#   bash bootstrap-03-scaffold.sh --clean
# This removes scaffold-generated content first, then recreates it.
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
CLEAN=0               # set to 1 with --clean to wipe scaffold outputs first

usage() {
  cat <<'TXT'
Usage:
  bash bootstrap-03-scaffold.sh [--clean] [--help]

Options:
  --clean   Remove scaffold-generated files/directories first, then rebuild.
  --help    Show this help message and exit.
TXT
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --clean)
        CLEAN=1
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "ERROR: Unknown option: $1"
        usage
        exit 1
        ;;
    esac
    shift
  done
}

parse_args "$@"

if [[ "$CLEAN" == "1" ]]; then
  # Clean mode implies overwrite behavior for any regenerated files.
  FORCE=1
fi

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

clean_scaffold() {
  echo "Clean mode enabled: removing scaffold-generated content."

  # Scoped cleanup only; never touches .git or bootstrap scripts.
  local clean_paths=(
    "README.md"
    "AGENTS.md"
    "MEMORY.md"
    "PLAN.md"
    "TODO.md"
    "CHAT.adoc"
    "STUDENT_START_HERE.md"
    ".gitignore"
    "lessons"
    "projects"
    "scripts"
    ".github/workflows"
    ".codex/prompts"
  )

  local path
  for path in "${clean_paths[@]}"; do
    if [[ -e "$path" ]]; then
      rm -rf -- "$path"
      echo "REMOVE: $path"
    fi
  done

  # Remove empty parent dirs if they no longer contain anything.
  rmdir .github 2>/dev/null || true
  rmdir .codex 2>/dev/null || true
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

if [[ "$CLEAN" == "1" ]]; then
  clean_scaffold
fi

# -----------------------------------------------------------------------------
# 1) Directory structure (matches current no-duplication publishing model)
# -----------------------------------------------------------------------------
# We keep authoring sources in /lessons only.
# Published site output is generated by CI into /site (artifact), not committed.
# /projects contains longer experiments (MicroPython + Pico SDK).
# /.codex contains Codex prompt templates so the repo is self-authoring.
mkdir_safe lessons
mkdir_safe projects/micropython
mkdir_safe projects/pico-sdk
mkdir_safe scripts
mkdir_safe .github/workflows
mkdir_safe .codex/prompts

# -----------------------------------------------------------------------------
# 2) README.md
# -----------------------------------------------------------------------------
write_file "README.md" <<'MD'
# RP2040 / RP2350 (Pico / Pico 2 / RP2040-Zero / RP2350-Zero) — Self-Study Course

This repository is a complete self-study course that you can build and follow
locally using **VS Code + the Codex extension**.

## Students: start here
- Local/student entry page: `STUDENT_START_HERE.md`
- Published site is generated by GitHub Actions from `lessons/`.

## Supported dev boards
- Raspberry Pi Pico (RP2040)
- Raspberry Pi Pico 2 (RP2350)
- RP2040-Zero
- RP2350-Zero

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
- `TODO.md`        — active/completed task tracking (`todos` / `done`)
- `CHAT.adoc`      — append-only project chat archive
- `AGENTS.md`      — instructions for Codex (how to work inside this repo)
- `lessons/`       — lesson sources (overview + assessment + code)
- `scripts/`       — tooling (including static-site generation)
- `.github/workflows/` — CI checks and GitHub Pages deploy
- `projects/`      — longer-running code projects (MicroPython + Pico SDK)
- `.codex/`        — Codex configuration + reusable prompts/templates

## Publishing
- Site is built from `lessons/` by `scripts/build_site.py`.
- GitHub Actions deploys the generated `site/` artifact to GitHub Pages.
- No hand-edited published copy is stored under `docs/`.
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
- Session-start convention:
  - first turn in a new session requires a lightweight baseline repo scan
  - minimum scan includes `git status --short` and `rg --files`
- Student-facing entry points are standardized:
  - repo-level `STUDENT_START_HERE.md`
- Publishing model:
  - `lessons/` is the single source of truth
  - GitHub Actions builds and deploys a generated `site/` artifact
  - no duplicated lesson copies are maintained in `docs/`
- Phase bootstrap approach:
  - Phase 1: local repo init + first commit contains bootstrap scripts
  - Phase 2: add remote + push
  - Phase 3: scaffold course structure (this file set)
- Task tracking convention:
  - use root `TODO.md` with `todos` and `done` sections
- Chat archive convention:
  - save project chat history in root `CHAT.adoc`
  - keep chat history append-only
  - auto-append every user/assistant turn to avoid end-of-session loss
  - do not require commit/push for chat-archive updates
  - do not include AsciiDoc TOC directives in `CHAT.adoc`

## Hardware assumptions (update when confirmed)
- Target boards:
  - Raspberry Pi Pico (RP2040)
  - Raspberry Pi Pico 2 (RP2350)
  - RP2040-Zero
  - RP2350-Zero
- Always state explicitly when a step is board-specific.
- Record any pin mappings used by lessons here.

## Nonvolatile storage policy
- RP2040/RP2350 do not have "classic AVR EEPROM" built-in.
- Use one of:
  - Flash-based key/value storage (with wear considerations)
  - File system on flash (LittleFS or similar) if available in the chosen runtime
- If we adopt a specific approach in lessons, record it here.

## Open questions / to verify (keep short)
- LED pin conventions for all supported boards in MicroPython + SDK.
- RP2040-Zero and RP2350-Zero board pin mapping differences vs Pico/Pico 2.
- RP2040-Zero and RP2350-Zero board voltage/power caveats for beginner lessons.
- Recommended THP sensor model for lessons (e.g., BME280/BMP280/SHT31 combo).
- Recommended keypad matrix size for the button-matrix lesson.

## Status log (append, don’t overwrite)
- YYYY-MM-DD: Phase 3 scaffold created.
MD

# -----------------------------------------------------------------------------
# 4) TODO.md (task tracker)
# -----------------------------------------------------------------------------
write_file "TODO.md" <<'MD'
# TODO

## todos

## done
MD

# -----------------------------------------------------------------------------
# 5) CHAT.adoc (project chat archive)
# -----------------------------------------------------------------------------
write_file "CHAT.adoc" <<'ADOC'
= Chat Transcript

NOTE: Append-only project chat archive.
ADOC

# -----------------------------------------------------------------------------
# 6) AGENTS.md (Codex-only workflow constitution)
# -----------------------------------------------------------------------------
write_file "AGENTS.md" <<'MD'
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

## Chat archive discipline
- Save project chat history in root `CHAT.adoc`.
- Keep it append-only; do not delete previous turns.
- Auto-append every user/assistant turn (not only end-of-session summaries).
- Write chat-archive updates without requiring commit/push unless explicitly requested.
- Do not add AsciiDoc TOC directives (`:toc:` / `:toclevels:`) to `CHAT.adoc`.

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

## Markdown formatting rules (mandatory)
- Never write “one-line” Markdown. Use normal line breaks.
- Headings (`#`, `##`, `###`) must be on their own line and followed by a blank line.
- Paragraphs must be separated by a blank line.
- Lists:
  - Put a blank line before a list.
  - Each list item must be on its own line starting with `- ` or `1. `.
  - Nested lists must be indented under the parent list item by **two spaces**.
  - Do not write inline lists like: `text: - a - b - c` (forbidden).
- Code fences must be surrounded by blank lines.
MD

# -----------------------------------------------------------------------------
# 7) PLAN.md (extended per your new requirements)
# -----------------------------------------------------------------------------
# We avoid renumbering existing lesson IDs. Instead, we add suffix lessons:
# - L04A: Nonvolatile storage (EEPROM equivalent)
# - L05A: THP sensor (temp/humidity/pressure) via I2C
# - L05B: Button matrix scanning (local keyboard)
#
# This preserves the earlier numbering and keeps diffs simple.
write_file "PLAN.md" <<'MD'
# RP2040 / RP2350 Pico Self-Study Course Plan (Pico / Pico 2 / RP2040-Zero / RP2350-Zero, 90-minute lessons)

Legend: ☐ not started · ☐ in progress · ☑ done

## Board coverage policy
- Core board targets for lessons:
  - Raspberry Pi Pico (RP2040)
  - Raspberry Pi Pico 2 (RP2350)
  - RP2040-Zero
  - RP2350-Zero
- Hardware lessons should call out board-specific differences when known.
- If a detail is uncertain (pin mapping, LED pin, voltage), mark TODO and record
  it in `MEMORY.md`.

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
☐ L12 Low power modes: compare RP2040-family vs RP2350-family boards
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
- published output generated by CI from lesson sources (no duplicated docs tree)
MD

# -----------------------------------------------------------------------------
# 8) Codex prompt templates (so the repo “authors itself”)
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

Update:
- PLAN.md: mark the lesson as ☐ in progress (or ☑ done if fully complete)
- MEMORY.md: record any decisions or discovered pitfalls
- Ensure site generation still works by running:
  - `./.venv/bin/python scripts/build_site.py` (preferred)
  - or `python3 scripts/build_site.py` if `.venv` is not used
MD

write_file ".codex/prompts/consistency-check.md" <<'MD'
# Codex Prompt Template: Consistency Check

Follow AGENTS.md strictly.

Task:
- Scan the repository for consistency:
  - Every lesson has overview.md and assessment.md
  - Site build succeeds (`./.venv/bin/python scripts/build_site.py` preferred; `python3 scripts/build_site.py` if `.venv` is not used)
  - PLAN.md matches existing lessons
  - MEMORY.md has no contradictions
  - Verify that all list items are on separate lines; flag inline `: -` patterns

Output:
- A short report in Markdown
- A list of proposed fixes (do not apply unless asked)
MD

# -----------------------------------------------------------------------------
# 9) Student entry page (local source view)
# -----------------------------------------------------------------------------
write_file "STUDENT_START_HERE.md" <<'MD'
# Student Start Here

Use this page as your main student entry point.

## Supported dev boards
- Raspberry Pi Pico (RP2040)
- Raspberry Pi Pico 2 (RP2350)
- RP2040-Zero
- RP2350-Zero

## Learning path
1. Open `PLAN.md` to see the roadmap.
2. Start with the first available lesson in `lessons/`.
3. For each lesson:
   - read `overview.md`
   - run files in `code/`
   - complete `assessment.md`

## Recommended workflow per lesson
1. Read `overview.md` fully before running commands.
2. Check board-specific notes (pin mapping, onboard LED, voltage) for your board.
3. Run the lesson code exactly as written.
4. If something fails, use lesson troubleshooting lines first.
5. Complete `assessment.md` at the end.
6. Write short notes in `lessons/<lesson-id>/notes.md`.

## Publishing model
- Source of truth is only `lessons/`.
- A static website is generated by `scripts/build_site.py`.
- GitHub Actions deploys generated `site/` to GitHub Pages.
- No hand-written lesson copies are stored in `docs/`.
MD

# -----------------------------------------------------------------------------
# 10) Site generation tooling
# -----------------------------------------------------------------------------
write_file ".gitignore" <<'MD'
# Generated static site output
site/

# Python cache
__pycache__/
*.pyc

# Local virtual environments
.venv/
MD

write_file "scripts/build_site.py" <<'PY'
#!/usr/bin/env python3
"""Generate a static learner site from lesson sources.

Usage:
  python3 scripts/build_site.py
"""

from __future__ import annotations

import fnmatch
import re
import shutil
from pathlib import Path

try:
    import markdown
except ModuleNotFoundError as exc:
    raise SystemExit(
        "Missing dependency: markdown. Install with: python3 -m pip install markdown"
    ) from exc


ROOT = Path(__file__).resolve().parent.parent
LESSONS_DIR = ROOT / "lessons"
SITE_DIR = ROOT / "site"
SITE_LESSONS_DIR = SITE_DIR / "lessons"
LESSON_DIR_RE = re.compile(r"^L[0-9A-Z]+-.+")
SKIP_SOURCE_DIR_GLOBS = ("build", "build-*", "__pycache__", ".pytest_cache")
SKIP_SOURCE_FILE_GLOBS = ("*.pyc",)
PUBLISHED_MD_HTML_BASENAMES = {"overview.md", "assessment.md", "notes.md"}

CSS = """
:root {
  color-scheme: light;
  --bg: #f6f7fb;
  --surface: #ffffff;
  --text: #1f2430;
  --muted: #5b6375;
  --accent: #0d6efd;
  --border: #dde2ef;
}
* { box-sizing: border-box; }
body {
  margin: 0;
  font-family: "Segoe UI", Tahoma, sans-serif;
  color: var(--text);
  background: radial-gradient(circle at 20% 0%, #e8eefc, var(--bg));
}
.wrap {
  max-width: 980px;
  margin: 0 auto;
  padding: 1.5rem 1rem 3rem;
}
header {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 1rem 1.25rem;
  margin-bottom: 1rem;
}
nav a {
  color: var(--accent);
  margin-right: 1rem;
  text-decoration: none;
  font-weight: 600;
}
article {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 1.25rem;
}
h1, h2, h3, h4 { line-height: 1.25; }
pre {
  background: #101522;
  color: #dbe7ff;
  padding: 0.85rem;
  border-radius: 8px;
  overflow-x: auto;
}
code {
  font-family: "Consolas", "SFMono-Regular", monospace;
}
ul, ol { padding-left: 1.35rem; }
a { color: var(--accent); }
.muted { color: var(--muted); }
"""


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def first_heading(markdown_text: str, fallback: str) -> str:
    for line in markdown_text.splitlines():
        if line.startswith("# "):
            return line[2:].strip()
    return fallback


def strip_leading_h1(markdown_text: str) -> str:
    lines = markdown_text.splitlines()
    idx = 0
    while idx < len(lines) and not lines[idx].strip():
        idx += 1
    if idx < len(lines) and lines[idx].startswith("# "):
        lines = lines[:idx] + lines[idx + 1 :]
    return "\n".join(lines).lstrip("\n")


def normalize_nested_list_indentation(markdown_text: str) -> str:
    """Adapt 2-space nested list authoring to Python-Markdown's parser behavior.

    Authoring rules in AGENTS.md use two-space nested lists. Python-Markdown
    often needs deeper indentation to keep nested items under their parent list.
    """
    out: list[str] = []
    in_fence = False
    list_item_re = re.compile(r"^( +)([-*+] |\d+\. )")

    for line in markdown_text.splitlines():
        if line.startswith("```"):
            in_fence = not in_fence
            out.append(line)
            continue

        if not in_fence:
            match = list_item_re.match(line)
            if match:
                leading_spaces = len(match.group(1))
                if leading_spaces >= 2:
                    line = (" " * (leading_spaces * 2)) + line[leading_spaces:]

        out.append(line)

    return "\n".join(out)


def normalize_indented_fenced_code_blocks(markdown_text: str) -> str:
    """Render list-indented fenced code blocks as nested indented code blocks.

    Python-Markdown does not reliably parse fenced code blocks nested in lists.
    This preserves readability for lesson steps with embedded commands.
    """
    lines = markdown_text.splitlines()
    out: list[str] = []
    idx = 0
    opening_re = re.compile(r"^( +)```([A-Za-z0-9_-]*)\s*$")

    while idx < len(lines):
        line = lines[idx]
        open_match = opening_re.match(line)
        if not open_match:
            out.append(line)
            idx += 1
            continue

        fence_indent = open_match.group(1)
        close_re = re.compile(rf"^{re.escape(fence_indent)}```\s*$")

        idx += 1
        code_lines: list[str] = []
        while idx < len(lines) and not close_re.match(lines[idx]):
            code_line = lines[idx]
            if code_line.startswith(fence_indent):
                code_line = code_line[len(fence_indent) :]
            code_lines.append(code_line)
            idx += 1

        if idx < len(lines):
            idx += 1

        # Indent enough to stay attached to the owning list item.
        code_indent = " " * (len(fence_indent) + 5)
        if out and out[-1] != "":
            out.append("")
        for code_line in code_lines:
            out.append(code_indent + code_line)
        out.append("")

    return "\n".join(out)


def merge_lesson_markdown(overview: str, assessment: str) -> str:
    overview_body = strip_leading_h1(overview).strip()
    assessment_body = strip_leading_h1(assessment).strip()
    return f"{overview_body}\n\n## Assessment\n\n{assessment_body}\n"


def rewrite_published_markdown_links(markdown_text: str) -> str:
    """Point lesson-doc markdown links to generated HTML pages."""

    link_re = re.compile(r"\]\(([^)]+)\)")

    def replace_link(match: re.Match[str]) -> str:
        target = match.group(1).strip()
        if not target:
            return match.group(0)
        if target.startswith(("#", "mailto:", "http://", "https://")):
            return match.group(0)

        path_part = target
        fragment = ""
        query = ""
        if "#" in path_part:
            path_part, frag_value = path_part.split("#", 1)
            fragment = f"#{frag_value}"
        if "?" in path_part:
            path_part, query_value = path_part.split("?", 1)
            query = f"?{query_value}"

        if Path(path_part).name not in PUBLISHED_MD_HTML_BASENAMES:
            return match.group(0)

        html_path = path_part[:-3] + ".html"
        return f"]({html_path}{query}{fragment})"

    return link_re.sub(replace_link, markdown_text)


def md_to_html(markdown_text: str, *, rewrite_doc_links: bool = False) -> str:
    normalized_md = normalize_nested_list_indentation(markdown_text)
    normalized_md = normalize_indented_fenced_code_blocks(normalized_md)
    if rewrite_doc_links:
        normalized_md = rewrite_published_markdown_links(normalized_md)
    return markdown.markdown(
        normalized_md,
        extensions=["fenced_code", "tables", "toc", "sane_lists"],
        output_format="html5",
    )


def render_page(title: str, body_html: str, asset_prefix: str = "") -> str:
    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{title}</title>
  <link rel="stylesheet" href="{asset_prefix}style.css">
</head>
<body>
  <div class="wrap">
    <header>
      <h1>{title}</h1>
      <nav>
        <a href="{asset_prefix}index.html">Home</a>
        <a href="{asset_prefix}syllabus.html">Syllabus</a>
      </nav>
    </header>
    <article>
      {body_html}
    </article>
  </div>
</body>
</html>
"""


def discover_lessons() -> list[Path]:
    if not LESSONS_DIR.exists():
        return []
    lesson_dirs = [
        path
        for path in LESSONS_DIR.iterdir()
        if path.is_dir() and LESSON_DIR_RE.match(path.name)
    ]
    return sorted(lesson_dirs, key=lambda path: path.name)


def copy_lesson_sources(lesson_dir: Path, lesson_site_dir: Path) -> None:
    def ignore_names(path: str, names: list[str]) -> set[str]:
        ignored: set[str] = set()
        path_obj = Path(path)
        for name in names:
            child = path_obj / name
            if child.is_dir():
                if any(fnmatch.fnmatch(name, glob) for glob in SKIP_SOURCE_DIR_GLOBS):
                    ignored.add(name)
            else:
                if any(fnmatch.fnmatch(name, glob) for glob in SKIP_SOURCE_FILE_GLOBS):
                    ignored.add(name)
        return ignored

    for name in ("overview.md", "assessment.md", "notes.md", "code"):
        src = lesson_dir / name
        if not src.exists():
            continue
        dst = lesson_site_dir / name
        if src.is_dir():
            shutil.copytree(src, dst, ignore=ignore_names)
        else:
            shutil.copy2(src, dst)


def write_site_files(lessons: list[tuple[str, str]]) -> None:
    lesson_links = "".join(
        f'<li><a href="lessons/{slug}/">{title}</a></li>\n'
        for slug, title in lessons
    )
    index_body = (
        "<p class=\"muted\">Published from lesson sources by GitHub Actions.</p>\n"
        "<p>Start with the syllabus:</p>\n"
        "<ul><li><a href=\"syllabus.html\">Open Syllabus</a></li></ul>\n"
    )
    syllabus_body = (
        "<p>The following lessons were generated from <code>lessons/</code>:</p>\n"
        f"<ul>\n{lesson_links}</ul>\n"
    )
    (SITE_DIR / "style.css").write_text(CSS.strip() + "\n", encoding="utf-8")
    (SITE_DIR / "index.html").write_text(
        render_page("RP Pico Self-Study", index_body),
        encoding="utf-8",
    )
    (SITE_DIR / "syllabus.html").write_text(
        render_page("Syllabus", syllabus_body),
        encoding="utf-8",
    )


def main() -> int:
    lessons = discover_lessons()
    if SITE_DIR.exists():
        shutil.rmtree(SITE_DIR)
    SITE_LESSONS_DIR.mkdir(parents=True, exist_ok=True)

    lesson_rows: list[tuple[str, str]] = []
    for lesson_dir in lessons:
        overview_path = lesson_dir / "overview.md"
        assessment_path = lesson_dir / "assessment.md"
        if not overview_path.exists() or not assessment_path.exists():
            # Keep build going for partial repositories.
            continue

        overview_text = read_text(overview_path)
        assessment_text = read_text(assessment_path)
        overview_body = strip_leading_h1(overview_text)
        assessment_body = strip_leading_h1(assessment_text)
        merged_md = merge_lesson_markdown(overview_text, assessment_text)
        lesson_title = first_heading(overview_text, lesson_dir.name)
        lesson_html = md_to_html(merged_md, rewrite_doc_links=True)
        overview_html = md_to_html(overview_body, rewrite_doc_links=True)
        assessment_html = md_to_html(assessment_body, rewrite_doc_links=True)

        lesson_site_dir = SITE_LESSONS_DIR / lesson_dir.name
        lesson_site_dir.mkdir(parents=True, exist_ok=True)
        copy_lesson_sources(lesson_dir, lesson_site_dir)

        out_path = lesson_site_dir / "index.html"
        out_path.write_text(
            render_page(lesson_title, lesson_html, asset_prefix="../../"),
            encoding="utf-8",
        )

        overview_out_path = lesson_site_dir / "overview.html"
        overview_out_path.write_text(
            render_page(f"{lesson_title} — Overview", overview_html, asset_prefix="../../"),
            encoding="utf-8",
        )

        assessment_out_path = lesson_site_dir / "assessment.html"
        assessment_out_path.write_text(
            render_page(
                f"{lesson_title} — Assessment",
                assessment_html,
                asset_prefix="../../",
            ),
            encoding="utf-8",
        )

        notes_path = lesson_dir / "notes.md"
        if notes_path.exists():
            notes_text = read_text(notes_path)
            notes_body = strip_leading_h1(notes_text)
            notes_title = first_heading(notes_text, f"{lesson_title} Notes")
            notes_html = md_to_html(notes_body, rewrite_doc_links=True)
            notes_out_path = lesson_site_dir / "notes.html"
            notes_out_path.write_text(
                render_page(notes_title, notes_html, asset_prefix="../../"),
                encoding="utf-8",
            )

        lesson_rows.append((lesson_dir.name, lesson_title))

    write_site_files(lesson_rows)
    print(f"Generated site for {len(lesson_rows)} lessons at: {SITE_DIR}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
PY
chmod +x scripts/build_site.py

# -----------------------------------------------------------------------------
# 11) GitHub Actions: check + Pages deploy
# -----------------------------------------------------------------------------
write_file ".github/workflows/site-check.yml" <<'YAML'
name: Site Check

on:
  pull_request:
  push:
    branches:
      - main

jobs:
  build-site:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: python -m pip install --upgrade pip markdown

      - name: Build site
        run: python scripts/build_site.py
YAML

write_file ".github/workflows/deploy-pages.yml" <<'YAML'
name: Deploy Pages

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: python -m pip install --upgrade pip markdown

      - name: Build site
        run: python scripts/build_site.py

      - name: Upload site artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: site

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
YAML

# -----------------------------------------------------------------------------
# 12) Lesson skeleton generator (placeholders Codex will expand)
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
# 13) Commit changes (Phase 3 should create a clean commit)
# -----------------------------------------------------------------------------
git add .

if git diff --cached --quiet; then
  echo "No changes staged; nothing to commit."
else
  git commit -m "Phase 3: scaffold Codex-only course + extend plan (storage, THP sensor, button matrix)"
fi

# -----------------------------------------------------------------------------
# 14) Final guidance for Codex-only workflow
# -----------------------------------------------------------------------------
cat <<'TXT'

Phase 3 complete.

Recommended next steps (Codex-only workflow):
1) Open this folder in VS Code.
2) Use Codex agent mode and follow AGENTS.md.
3) Start with L00 and fully implement it (overview + assessment + runnable steps).
4) Use .codex/prompts/lesson-generator.md as your standard prompt template.
5) Build a local preview site with: ./.venv/bin/python scripts/build_site.py
   (or python3 scripts/build_site.py if you are not using .venv)
6) Keep MEMORY.md updated when hardware/toolchain decisions are made.
7) Track active/completed tasks in TODO.md (`todos` / `done`).
8) Keep CHAT.adoc append-only and auto-append every user/assistant turn.

Notes:
- This script does not touch remotes and does not push.
- Push whenever you want using normal git commands.
- Use --clean when you want to wipe scaffold outputs and regenerate from zero.

TXT
