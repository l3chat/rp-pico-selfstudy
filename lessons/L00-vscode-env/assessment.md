# L00 — Assessment

## Navigation

- [Lesson overview](overview.md)
- [Code assets README](code/README.md)

Source files for this assessment:

- [`code/verify_env.py`](code/verify_env.py)
- [`code/micropython/hello_repl.py`](code/micropython/hello_repl.py)
- [`code/pico-sdk-usb-hello/main.c`](code/pico-sdk-usb-hello/main.c)

## How to use this assessment

- Time budget: 15 minutes
- Do not look up answers first. Answer from memory.
- Then run the practical task and self-grade with the rubric.

## Quiz (short self-check)

1. Name the 3 required host tools checked by `verify_env.py`, what each one does, and the package/app names you used to install them.
2. What serial command template is used in this lesson to open a terminal monitor?
3. Why does the MicroPython smoke test avoid onboard LED examples in L00?
4. What environment variable must be set before building the Pico SDK sample?
5. If your board port does not appear, what are the first two checks you should do?
6. On Linux, if `miniterm` returns `Permission denied` on `/dev/ttyACM0`, what is the persistent fix?
7. If serial says `Could not exclusively lock port`, what does it mean and what command helps identify the holder?
8. If serial opens but shows no `tick` output, what is the fastest recovery action in this lesson?

## Practical task

Complete this workflow without skipping steps:

1. In the repo root, run:

   ```bash
   python3 lessons/L00-vscode-env/code/verify_env.py
   ```

2. Open and explain these files out loud (or in notes):

  - [`code/micropython/hello_repl.py`](code/micropython/hello_repl.py)
  - [`code/pico-sdk-usb-hello/main.c`](code/pico-sdk-usb-hello/main.c)

3. Write 4 lines in a temporary note that include:

  - your board model
  - your serial port name
  - whether required tools passed
  - one missing recommended tool (or "none")

4. Prepare the serial monitor command you will use in L01, with your real port:

   ```bash
   python3 -m serial.tools.miniterm <YOUR_PORT> 115200
   ```

## Rubric (self-grading)

Score each item as 0 or 1.

- [ ] I ran `verify_env.py` myself and read the summary output.
- [ ] I can explain the MicroPython smoke-test script purpose.
- [ ] I can explain the Pico SDK smoke-test script purpose.
- [ ] I identified a likely serial port for my board.
- [ ] I prepared a usable serial monitor command for my machine.
- [ ] I understand at least one troubleshooting action for missing ports.
- [ ] I know the Linux fix for serial `Permission denied` without using `sudo`.
- [ ] I know how to recover from a locked port or a no-output serial session.

Scoring:

- 8/8: Ready to continue to L01.
- 6-7/8: Continue to L01, but keep this lesson open as reference.
- 0-5/8: Repeat L00 guided steps before L01.

## Answer key / hints

1. Required tools: `git`, `python3`, `cmake`.
   What they do: `git` tracks changes, `python3` runs repo scripts, `cmake` configures SDK builds.
   Common install names: `git`, Python 3 installer/`python3`, `cmake`.
   Official sources: `git-scm.com`, `python.org`, `cmake.org`.

2. `python3 -m serial.tools.miniterm <PORT> 115200`
3. LED pin mapping may differ across supported boards; L00 avoids unverified hardware assumptions.
4. `PICO_SDK_PATH`
5. Check cable type (must support data), then reconnect board and rescan ports.
6. Add your user to `dialout` with `sudo usermod -aG dialout "$USER"`, then log out and log back in.
7. Another process already holds the port; run `sudo fuser -v /dev/ttyACM0` to identify it.
8. Re-upload `hello_repl.py` as `main.py`, reset the board, and retry serial monitor.
