# TODO

## todos

## done
- 2026-02-12: L00 tool map now states what each tool does, plus package/extension IDs and official install sources.
- 2026-02-13: Reformatted lesson Markdown files to comply with AGENTS.md structure rules (headings, list spacing, nested list indentation, fenced code spacing).
- 2026-02-13: Updated bootstrap generation to align with current repo conventions for `AGENTS.md` and `.codex/prompts/consistency-check.md` (including markdown format-compliance checks).
- 2026-02-13: Installed `markdown` globally and validated site generation with `/usr/bin/python3 scripts/build_site.py` (8 lessons generated).
- 2026-02-13: Installed `markdown` in project `.venv` and validated site generation with `./.venv/bin/python scripts/build_site.py` (8 lessons generated).
- 2026-02-13: Updated `scripts/build_site.py` and bootstrap template to remove duplicate lesson H1 in rendered pages, preserve nested list structure from two-space-authored Markdown, and render list-nested code blocks correctly.
- 2026-02-13: Expanded `lessons/L00-vscode-env/code/verify_env.py` to include full L00 tool-map checks (host tools, Python packages, `PICO_SDK_PATH`, VS Code CLI, and required extension IDs).
- 2026-02-13: Added explicit Pico SDK installation instructions to L00 (Linux quick path + official macOS/Windows references) and aligned L00 code README build flow.
- 2026-02-13: Hardened `lessons/L00-vscode-env/code/pico-sdk-usb-hello/CMakeLists.txt` to accept `PICO_SDK_PATH` from CMake cache/env with `$HOME/opt/pico-sdk` fallback, plus added CMake troubleshooting notes in L00 docs.
- 2026-02-13: Updated `.gitignore` to ignore generated L00 Pico SDK lesson build directories (`build/` and `build-repro*/`) so local CMake outputs stay untracked.
- 2026-02-13: Added repo `.vscode/settings.json`, enabled `CMAKE_EXPORT_COMPILE_COMMANDS` in the L00 Pico SDK sample, and documented IDE include-error troubleshooting so VS Code IntelliSense resolves `pico/stdlib.h`.
- 2026-02-13: Added Linux serial `Permission denied` troubleshooting to L00 overview/code README/assessment (dialout group + relogin flow), and fixed literal `\\n` output in `pico-sdk-usb-hello/main.c`.
- 2026-02-13: Completed MicroPython smoke-test documentation in L00 (run options, expected startup/tick output, stop behavior, and troubleshooting) across overview/code README/script docstring.
- 2026-02-13: Added direct official MicroPython UF2 download links and BOOTSEL flash steps to L00 overview and code README.
- 2026-02-13: Clarified L00 Zero-board firmware wording: dedicated official board-name pages may be absent; use chip-family `RPI_PICO`/`RPI_PICO2` pages first, then vendor guidance.
