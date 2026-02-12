# L00 — VS Code Development Environment (90 minutes)

## Outcome (what you will have at the end)
By the end of this lesson, you will have:
- a working VS Code workspace for this course
- a verified host toolchain baseline (`git`, `python3`, `cmake`)
- a tested serial terminal workflow
- one MicroPython smoke-test script ready to run
- one Pico SDK USB-serial hello project ready to build

## Prerequisites
- No prior programming experience required
- A computer with admin rights to install software
- One supported board:
  - Raspberry Pi Pico (RP2040)
  - Raspberry Pi Pico 2 (RP2350)
  - RP2040-Zero
  - RP2350-Zero

## Safety and board-specific notes
- This lesson is intentionally board-neutral and avoids pin-specific examples.
- If a board detail is unclear (boot mode button sequence, UF2 drive label, onboard LED pin), check your board vendor docs and record findings in `MEMORY.md`.
- Do not force cables or connectors. If USB connection feels unstable, stop and reseat.

## Time plan (90 minutes)
- 0–10 min: orientation
- 10–25 min: install and verify VS Code + extensions
- 25–40 min: verify local toolchain with the provided script
- 40–55 min: serial monitor workflow setup
- 55–75 min: MicroPython and Pico SDK smoke-test setup
- 75–90 min: self-check and assessment

## 0–10 min: Orientation

### Why this lesson exists
You need one repeatable workflow before writing embedded code. In this course, that workflow is:
- edit in VS Code
- run commands in VS Code terminal
- test with serial output
- track progress in this repo

### Checkpoint
- [ ] You can explain the difference between:
  - host tools (run on your computer)
  - board firmware (runs on RP2040/RP2350)

If you cannot explain it yet: pause and restate this in your own words before moving on.

## 10–25 min: Install VS Code + required extensions

### Step 1: Install VS Code
- Install from the official site for your OS.
- Open this repository folder in VS Code.

Expected result:
- VS Code opens with this repo in the Explorer panel.

If you see "folder is read-only":
- move the repo to a writable location and reopen it.

### Step 2: Install required extensions
Install these extensions in VS Code:
- `ms-python.python` (Python)
- `ms-vscode.cpptools` (C/C++)
- `ms-vscode.cmake-tools` (CMake Tools)

Expected result:
- Each extension appears as installed in the Extensions view.

If extension install fails:
- verify internet access and retry.
- restart VS Code and try again.

## 25–40 min: Verify host toolchain

### Step 3: Open the integrated terminal
- VS Code menu: Terminal -> New Terminal
- Confirm terminal opens in repo root.

Run:
```bash
pwd
```

Expected result:
- Path ends with `rp-pico-selfstudy`.

If terminal opens in another directory:
- run `cd /path/to/rp-pico-selfstudy`.

### Step 4: Run the environment checker
Run:
```bash
python3 lessons/L00-vscode-env/code/verify_env.py
```

What this script checks:
- required: `git`, `python3`, `cmake`
- recommended for later lessons: `ninja`, `arm-none-eabi-gcc`, `picotool`, `mpremote`

Expected result:
- You see a status table and a final summary line.
- Missing required tools are clearly listed.

If you see "python3: command not found":
- install Python 3 and rerun.

If `arm-none-eabi-gcc` is missing:
- this is normal before SDK setup.
- install later during L01 if you are not doing C/C++ today.

## 40–55 min: Serial monitor workflow setup

### Step 5: Install a serial terminal tool (Python package)
Run:
```bash
python3 -m pip install --user pyserial
```

Expected result:
- Install completes without errors.

If you see a permissions error:
- keep `--user` and rerun.

### Step 6: Prepare serial monitor command
Command template:
```bash
python3 -m serial.tools.miniterm <PORT> 115200
```

Find your serial port:
- Linux: `ls /dev/ttyACM* /dev/ttyUSB* 2>/dev/null`
- macOS: `ls /dev/tty.usb* /dev/cu.usb* 2>/dev/null`
- Windows: check Device Manager -> Ports (COM & LPT)

Expected result:
- You can identify one candidate port for your board.

If no port appears:
- check USB cable is data-capable (not charge-only).
- reconnect the board.

## 55–75 min: MicroPython and Pico SDK smoke-test setup

### Step 7: Review the MicroPython smoke-test file
Open:
- `lessons/L00-vscode-env/code/micropython/hello_repl.py`

This file only prints counters over serial. It does not assume LED pins.

Expected result:
- You understand what output to expect (`tick 0`, `tick 1`, ...).

### Step 8: Review the Pico SDK smoke-test project
Open:
- `lessons/L00-vscode-env/code/pico-sdk-usb-hello/CMakeLists.txt`
- `lessons/L00-vscode-env/code/pico-sdk-usb-hello/main.c`

Build commands (after Pico SDK/toolchain install):
```bash
cd lessons/L00-vscode-env/code/pico-sdk-usb-hello
mkdir -p build
cd build
cmake .. -DPICO_BOARD=<YOUR_BOARD_ID>
cmake --build .
```

Expected result:
- Build generates firmware outputs (including UF2).

If CMake says `PICO_SDK_PATH is not set`:
- set the environment variable first, then rerun.

If board ID is unknown:
- use your board documentation; record verified ID in `MEMORY.md`.

## 75–90 min: Reflection + assessment handoff

### Explain-it-back prompts
Answer in your own words:
1. Why do we verify host tools before flashing a board?
2. What is the difference between MicroPython workflow and Pico SDK workflow?
3. Why is serial output used as a first health check?

### Final checklist for L00
- [ ] VS Code installed and repo opened
- [ ] Required extensions installed
- [ ] `verify_env.py` executed
- [ ] Serial monitor command prepared
- [ ] MicroPython smoke-test file reviewed
- [ ] Pico SDK smoke-test project reviewed
- [ ] Ready for assessment

Proceed to `assessment.md`.
