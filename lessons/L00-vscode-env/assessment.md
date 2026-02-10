# L00 — Assessment

## Quiz (self-check)
1. What does `PICO_SDK_PATH` point to, and why does CMake need it?
2. What is the practical difference between "enter BOOTSEL mode" and "normal runtime mode"?
3. Name two signs that a USB cable is likely power-only (not data-capable).
4. In this repo, what is the role of `MEMORY.md`?
5. Where should learner-facing published lesson pages be stored?
6. You can run `mpremote connect auto run <script.py>`. What does this command do in one line?

## Practical task
Goal: Prove your workstation can do both core workflows (MicroPython and Pico SDK).

Steps:
1. Run:

```bash
python3 lessons/L00-vscode-env/code/env_check.py --strict
```

If `python3` is not recognized, use `python` or `py -3`.

2. Flash MicroPython UF2 to your board, then run:

```bash
mpremote connect auto run lessons/L00-vscode-env/code/micropython_hello.py
```

3. Build the Pico SDK sample:

```bash
cd lessons/L00-vscode-env/code/pico_sdk_hello
cmake -S . -B build -G Ninja
cmake --build build
```

4. Flash `build/l00_pico_sdk_hello.uf2` and verify serial text appears.
5. Create a short file `lessons/L00-vscode-env/notes.md` containing:
   - your OS
   - commands that worked
   - one failure you hit and how you fixed it

## Rubric (how to grade yourself)
- Pass if:
  - Quiz: at least 5/6 answers are correct.
  - Environment check: all required tools pass in strict mode.
  - MicroPython flow: script output is visible from board runtime.
  - Pico SDK flow: UF2 is produced and flashed successfully.
  - Reflection note: `notes.md` is complete and specific.

## Quiz answer key (check after attempting)
1. It is the local path to the Pico SDK checkout; CMake imports SDK build logic from it.
2. BOOTSEL mode exposes the board as a mass-storage device for UF2 flashing; normal mode runs firmware.
3. The board powers on but no serial device appears, and BOOTSEL drive never mounts.
4. It records project decisions, conventions, and verified differences/questions over time.
5. `docs/lessons/`
6. It connects to the board and executes the given script immediately over MicroPython transport.
