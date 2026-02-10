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
  - published `docs/student-start-here.md`
- L00 development-environment baseline:
  - use `lessons/L00-vscode-env/code/env_check.py` for host preflight checks
  - use `mpremote` as the default MicroPython run/upload CLI
  - use `cmake` + `arm-none-eabi-gcc` (+ `ninja` when available) for Pico SDK builds
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
- 2026-02-10: L00 fully implemented (overview, assessment, code bundle, published page).
- 2026-02-10: Added explicit student entry pages and linked them from README/docs index.
- 2026-02-10: Added required session-start baseline scan rule to AGENTS.md.
