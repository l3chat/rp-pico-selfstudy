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
- 2026-02-13: Expanded L00 serial guidance with practical recovery patterns from live testing: `miniterm` controls, locked-port handling (`fuser`/`kill`), no-output recovery by re-uploading `hello_repl.py` as `main.py`, and REPL paste-mode steps.
- 2026-02-13: Added L00 navigation/source-file links and reordered MicroPython steps to a more natural sequence (flash firmware before running the smoke test).
- 2026-02-13: Fixed published source-link paths by changing site generation to per-lesson directories (`site/lessons/<lesson>/index.html`) and copying lesson source files into each lesson output directory.
- 2026-02-13: Added project chat-archive discipline: append project chat turns to root `CHAT.adoc` and keep it append-only.
- 2026-02-13: Updated `bootstrap-03-scaffold.sh` so scaffolded repos include `CHAT.adoc` conventions (generated file, AGENTS/MEMORY guidance, README listing, and `--clean` removal path).
- 2026-02-13: Fixed publishing gap where lesson assessments stayed Markdown-only by generating `overview.html` and `assessment.html` per lesson (plus optional `notes.html`), rewriting lesson doc links to `.html`, and syncing this behavior in bootstrap-generated `scripts/build_site.py`.
- 2026-02-13: Disabled chat archive table of contents generation by removing AsciiDoc `:toc:` directives from `CHAT.adoc` and the scaffolded `CHAT.adoc` template in `bootstrap-03-scaffold.sh`.
- 2026-02-13: Enabled per-turn chat auto-append without commit/push by updating repo and bootstrap chat-archive conventions.
