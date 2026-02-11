# L00 — VS Code Development Environment (90 minutes)

## Outcome (what you will have at the end)
- A working VS Code workspace for this course.
- A repeatable host-machine tool check (`code/env_check.py`).
- One verified MicroPython workflow (flash + run script + serial output).
- One verified Pico SDK workflow (configure + build UF2).
- A clear Codex workflow inside this repository (`AGENTS.md`, `PLAN.md`, `MEMORY.md`).

## Prerequisites
- No prior programming knowledge required.
- Laptop/desktop with admin rights.
- Raspberry Pi Pico (RP2040) or Pico 2 (RP2350).
- USB data cable (not charge-only).
- Internet access for downloading tools and firmware.

## Lesson files
- `lessons/L00-vscode-env/code/env_check.py`
- `lessons/L00-vscode-env/code/micropython_hello.py`
- `lessons/L00-vscode-env/code/pico_sdk_hello/`

## 90-minute plan
### 0–10 min: Orientation

Checklist:
- [ ] Open this repository in VS Code.
- [ ] Open `AGENTS.md` and skim the rules.
- [ ] Open `PLAN.md` and locate lesson `L00`.
- [ ] Open `MEMORY.md` and see where decisions are recorded.

How to open this repository as a workspace (first time):
1. In VS Code, go to `File > Open Folder...`.
2. Select the `rp-pico-selfstudy` folder, then choose `Open` (or `Select Folder`).
3. If VS Code asks whether you trust the authors, choose `Yes, I trust the authors`.
4. Confirm the left sidebar (Explorer) shows top-level files like `AGENTS.md`, `PLAN.md`, `lessons/`, and `docs/`.

How to read Markdown files in VS Code:
1. Open any `.md` file (for example `lessons/L00-vscode-env/overview.md`).
2. Open Markdown Preview in the same tab:
   - Windows/Linux: `Ctrl+Shift+V`
   - macOS: `Cmd+Shift+V`
3. Open Markdown Preview side-by-side with the source:
   - Windows/Linux: `Ctrl+K` then `V`
   - macOS: `Cmd+K` then `V`
4. Keep the editor on the left and preview on the right while you read or edit.

Expected result:
- You know where lesson content lives (`lessons/`) and where published pages live (`docs/`).
- You understand that this course uses VS Code + Codex as the main workflow.
- You can open course Markdown files in preview mode and read them comfortably.

Troubleshooting:
- If you see "workspace trust" prompts in VS Code, choose to trust this folder so terminals and tasks can run.
- If links/images in Markdown preview do not resolve, you probably opened a single file instead of the folder. Re-open with `File > Open Folder...`.
- If Markdown preview does not open, check that the file extension is `.md` and retry the keyboard shortcut.

### 10–65 min: Guided build

#### 10–25 min: Install and verify host tools

1. Install host tools if missing.
   Use the exact command/package names below (these match `env_check.py`):

| Required | Command checked | Package/App name to install | What it is used for |
|---|---|---|---|
| Yes | `python3` | `python3` (Python 3) | Runs lesson scripts and tooling (`env_check.py`, `pip`, helpers). |
| Yes | `git` | `git` | Cloning/updating repositories and course version control. |
| Yes | `cmake` | `cmake` | Configures Pico SDK C/C++ builds. |
| Yes | `arm-none-eabi-gcc` | `gcc-arm-none-eabi` (Debian/Ubuntu) or `arm-none-eabi-gcc` (Homebrew) | Cross-compiler for RP2040/RP2350 firmware. |
| No (recommended) | `code` | Visual Studio Code (`code` CLI command) | Main editor workflow used by this course. |
| No (recommended) | `ninja` | `ninja` (or `ninja-build` on Debian/Ubuntu) | Faster build backend for CMake (`-G Ninja`). |
| No (recommended) | `mpremote` | Python package `mpremote` | Upload/run MicroPython scripts over USB serial. |
| No (optional) | `picotool` | `picotool` | Inspect board/flash metadata and UF2-related device info. |

2. In a VS Code terminal, run:

```bash
python3 lessons/L00-vscode-env/code/env_check.py
```

   If `python3` is not recognized on your system, use `python` or `py -3`.

3. If you want the command to fail when required tools are missing, run:

```bash
python3 lessons/L00-vscode-env/code/env_check.py --strict
```

Expected result:
- You get a tool report with `OK`, `MISSING`, or `ERROR`.
- You know exactly what still needs installation.

Troubleshooting:
- If you see `python3: command not found`, install Python 3 and restart VS Code.
- If `code` is missing but VS Code is installed, install the VS Code shell command from VS Code's Command Palette.
- If `arm-none-eabi-gcc` is missing, install the ARM embedded GCC toolchain for your OS and re-run the check.

#### 25–40 min: MicroPython upload + serial workflow

1. Download the MicroPython UF2 for your board model (Pico or Pico 2).
2. Enter BOOTSEL mode:
   - Hold `BOOTSEL` on the board.
   - Plug in USB.
   - Release `BOOTSEL` when a USB drive appears.
3. Copy the UF2 onto the mounted drive. The board reboots automatically.
4. Run the lesson script:

```bash
mpremote connect auto run lessons/L00-vscode-env/code/micropython_hello.py
```

Expected result:
- You see lines like `L00 MicroPython hello` and `tick: 0` in terminal output.

Troubleshooting:
- If you see `mpremote: command not found`, install it with `python3 -m pip install --user mpremote`.
- If no board is detected, try a different USB cable (many failures are charge-only cables).
- If the board does not mount in BOOTSEL mode, unplug and retry while holding BOOTSEL before power is applied.

#### 40–55 min: Pico SDK build workflow

1. Clone Pico SDK (one-time setup):

```bash
git clone --depth=1 https://github.com/raspberrypi/pico-sdk.git "$HOME/pico-sdk"
```

2. Set `PICO_SDK_PATH`:
   - macOS/Linux:

```bash
export PICO_SDK_PATH="$HOME/pico-sdk"
```

   - Windows PowerShell:

```powershell
$env:PICO_SDK_PATH="$HOME\pico-sdk"
```

3. Build the sample:

```bash
cd lessons/L00-vscode-env/code/pico_sdk_hello
cmake -S . -B build -G Ninja
cmake --build build
```

4. Flash UF2:
   - Put board in BOOTSEL mode.
   - Copy `build/l00_pico_sdk_hello.uf2` to the board drive.

Expected result:
- Build completes without fatal errors.
- `build/l00_pico_sdk_hello.uf2` exists.
- Serial output prints `L00 Pico SDK hello`.

Troubleshooting:
- If CMake says `PICO_SDK_PATH` is not set, set it and configure again.
- If Ninja is missing, install Ninja or use another generator (`-G "Unix Makefiles"`).
- If flashing works but you see no serial text, unplug/replug and reconnect your serial monitor.

#### 55–65 min: Codex workflow inside this repo

Checklist:
- [ ] Use `AGENTS.md` as the source of project rules.
- [ ] Keep `PLAN.md` updated when lesson status changes.
- [ ] Add decisions/open questions to `MEMORY.md`.
- [ ] Keep published learner pages in `docs/lessons/` standalone and easy to navigate.

Expected result:
- You can explain the difference between source lessons (`lessons/`) and published pages (`docs/lessons/`).

Troubleshooting:
- If a change feels ambiguous, write a short TODO in the lesson plus a matching note in `MEMORY.md`.

### 65–75 min: Explain it back

Answer these out loud or in writing:
1. Why do we keep both `lessons/` and `docs/lessons/`?
2. What is the difference between a MicroPython UF2 flow and a Pico SDK CMake flow?
3. When should `MEMORY.md` be updated?

Expected result:
- You can describe the workflow without copying commands.

### 75–90 min: Assessment
- Complete `assessment.md`.
