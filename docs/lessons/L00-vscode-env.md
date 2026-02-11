# L00 — VS Code Development Environment

Source lesson: `lessons/L00-vscode-env/`

## Outcome
- VS Code workspace ready for this course.
- Host toolchain verified with `env_check.py`.
- MicroPython flash/run workflow verified.
- Pico SDK configure/build workflow verified.

## 90-minute map
- 0–10 min: Orientation (`AGENTS.md`, `PLAN.md`, `MEMORY.md`)
- 10–65 min: Guided setup and first runs
- 65–75 min: Explain-it-back questions
- 75–90 min: Assessment

## Quick checklist
- [ ] Open this repo as a workspace:
  - VS Code -> `File > Open Folder...` -> select `rp-pico-selfstudy`.
  - Trust the workspace when prompted.
- [ ] Read Markdown with preview:
  - Same tab: `Ctrl+Shift+V` (`Cmd+Shift+V` on macOS)
  - Side-by-side: `Ctrl+K` then `V` (`Cmd+K` then `V` on macOS)
- [ ] Run host check:

```bash
python3 lessons/L00-vscode-env/code/env_check.py --strict
```

If `python3` is not recognized, use `python` or `py -3`.

- [ ] Run MicroPython sample:

```bash
mpremote connect auto run lessons/L00-vscode-env/code/micropython_hello.py
```

- [ ] Build Pico SDK sample:

```bash
cd lessons/L00-vscode-env/code/pico_sdk_hello
cmake -S . -B build -G Ninja
cmake --build build
```

- [ ] Flash `build/l00_pico_sdk_hello.uf2` in BOOTSEL mode.

## Expected results
- `env_check.py --strict` reports all required tools as `OK`.
- MicroPython script prints `L00 MicroPython hello` and `tick` lines.
- CMake build creates `l00_pico_sdk_hello.uf2`.

## Troubleshooting quick fixes
- If `python3` is missing: install Python 3 and restart VS Code.
- If `mpremote` is missing: `python3 -m pip install --user mpremote`.
- If `PICO_SDK_PATH` is not set: set it to your `pico-sdk` folder and re-run CMake.
- If board is not detected: replace USB cable (must support data, not just charging).
- If Markdown links do not render: re-open the project with `File > Open Folder...` instead of opening a single `.md` file.

## Assessment
Complete: `lessons/L00-vscode-env/assessment.md`
