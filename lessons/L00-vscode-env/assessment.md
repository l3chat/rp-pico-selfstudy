# L00 — Assessment

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

## Practical task
Complete this workflow without skipping steps:

1. In the repo root, run:
```bash
python3 lessons/L00-vscode-env/code/verify_env.py
```

2. Open and explain these files out loud (or in notes):
- `lessons/L00-vscode-env/code/micropython/hello_repl.py`
- `lessons/L00-vscode-env/code/pico-sdk-usb-hello/main.c`

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

Scoring:
- 6/6: Ready to continue to L01.
- 4-5/6: Continue to L01, but keep this lesson open as reference.
- 0-3/6: Repeat L00 guided steps before L01.

## Answer key / hints
1. Required tools: `git`, `python3`, `cmake`.
   What they do: `git` tracks changes, `python3` runs repo scripts, `cmake` configures SDK builds.
   Common install names: `git`, Python 3 installer/`python3`, `cmake`.
   Official sources: `git-scm.com`, `python.org`, `cmake.org`.
2. `python3 -m serial.tools.miniterm <PORT> 115200`
3. LED pin mapping may differ across supported boards; L00 avoids unverified hardware assumptions.
4. `PICO_SDK_PATH`
5. Check cable type (must support data), then reconnect board and rescan ports.
