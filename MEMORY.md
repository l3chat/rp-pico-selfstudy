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
- Task tracking convention:
  - repo-level `TODO.md` with `todos` and `done` sections
- Publishing model:
  - `lessons/` is the single source of truth
  - GitHub Actions builds and deploys a generated `site/` artifact
  - no duplicated lesson copies are maintained in `docs/`
- Python tooling convention:
  - prefer project `.venv` for local Python commands when available
  - use `./.venv/bin/python scripts/build_site.py` for local site-build checks
- Phase bootstrap approach:
  - Phase 1: local repo init + first commit contains bootstrap scripts
  - Phase 2: add remote + push
  - Phase 3: scaffold course structure (this file set)
- L00 environment lesson convention:
  - use board-neutral serial smoke tests first
  - avoid LED/pin-based examples until board mappings are verified
  - Pico SDK sample CMake accepts `PICO_SDK_PATH` from cache var or environment,
    with `$HOME/opt/pico-sdk` as a beginner-friendly fallback
  - ignore lesson-local CMake build output directories in git tracking
  - repo-level VS Code settings point CMake Tools and C/C++ IntelliSense to
    `lessons/L00-vscode-env/code/pico-sdk-usb-hello` and its `build/compile_commands.json`
  - Linux serial access troubleshooting uses persistent `dialout` group membership
    and relogin (avoid requiring `sudo` for routine `miniterm` use)
  - MicroPython L00 smoke-test description must include run method, exact expected
    startup/tick output pattern, and basic troubleshooting checks
  - MicroPython setup docs include direct official UF2 download links for Pico and Pico 2
    plus explicit BOOTSEL flash steps

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
- UF2 boot-mode entry steps and mass-storage behavior for RP2040-Zero and RP2350-Zero.
- RP2040-Zero and RP2350-Zero board pin mapping differences vs Pico/Pico 2.
- RP2040-Zero and RP2350-Zero board voltage/power caveats for beginner lessons.
- Recommended THP sensor model for lessons (e.g., BME280/BMP280/SHT31 combo).
- Recommended keypad matrix size for the button-matrix lesson.

## Status log (append, don’t overwrite)
- YYYY-MM-DD: Phase 3 scaffold created.
- 2026-02-12: Completed full L00 lesson with runnable environment-check and serial smoke-test code.
- 2026-02-12: Added repo-level `TODO.md` and aligned AGENTS/bootstrap scaffolding with `todos`/`done` tracking.
- 2026-02-13: Normalized lesson Markdown structure across `lessons/**/*.md` to follow AGENTS formatting rules (blank lines around headings/lists/code fences and proper two-space nested lists).
- 2026-02-13: Added consistency-check prompt rule to flag inline list patterns (`: -`) and mirrored it in bootstrap scaffold generation.
- 2026-02-13: Updated bootstrap AGENTS template to include mandatory Markdown formatting rules so scaffolded repos inherit current style constraints.
- 2026-02-13: Local shell `python3` points to `/home/lechat/envdf/bin/python3` (no `markdown`), while global `/usr/bin/python3` has `markdown`; site build validated with `/usr/bin/python3 scripts/build_site.py`.
- 2026-02-13: Installed `markdown` in project `.venv`; site build validated with `./.venv/bin/python scripts/build_site.py` (8 lessons generated). `.venv/` is now ignored in git.
- 2026-02-13: Updated Codex prompt templates and bootstrap guidance to prefer `.venv` for local `build_site.py` checks, with `python3` as fallback when `.venv` is not used.
- 2026-02-13: Updated site generator and bootstrap template to strip duplicate lesson H1 from article HTML, normalize nested list indentation for two-space-authored Markdown, and convert list-indented fenced code blocks into nested code blocks for reliable rendering.
- 2026-02-13: Expanded L00 `verify_env.py` coverage to check full tool map items (host tools, Python packages, `PICO_SDK_PATH`, VS Code CLI, and required extension IDs), and documented `.venv`-aware package-check behavior.
- 2026-02-13: Added explicit Pico SDK install instructions in L00 overview/code README (Linux quick path with official macOS/Windows references) and switched sample build command to include `-GNinja`.
- 2026-02-13: Updated L00 Pico SDK sample `CMakeLists.txt` to resolve SDK path from `-DPICO_SDK_PATH`, environment `PICO_SDK_PATH`, or `$HOME/opt/pico-sdk`, and added troubleshooting notes for SDK path and picotool fetch failures.
- 2026-02-13: Updated `.gitignore` to ignore generated `pico-sdk-usb-hello` build directories (`build/` and `build-repro*/`) so local CMake output does not pollute git status.
- 2026-02-13: Added `.vscode/settings.json` for L00 CMake project IntelliSense (`configurationProvider`, `compileCommands`, source/build directories), enabled `CMAKE_EXPORT_COMPILE_COMMANDS` in lesson CMake, and added include-error troubleshooting notes in L00 docs.
- 2026-02-13: Added Linux serial `Permission denied` troubleshooting (dialout group + relogin + `fuser` check) to L00 overview/code README/assessment, and fixed Pico SDK smoke-test output to print real newlines.
- 2026-02-13: Expanded L00 MicroPython smoke-test documentation in overview/code README/script docstring with explicit run options, expected startup + tick output, stop behavior, and troubleshooting.
- 2026-02-13: Added direct official MicroPython UF2 download links (`download`, `RPI_PICO`, `RPI_PICO2`) and BOOTSEL flash steps to L00 overview/code README.
