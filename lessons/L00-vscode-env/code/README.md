# L00 Code Assets

This folder contains minimal runnable examples used in lesson L00.

## Files

- `verify_env.py` — checks host tooling (required + recommended)
- `micropython/hello_repl.py` — serial heartbeat script for MicroPython
- `pico-sdk-usb-hello/` — minimal Pico SDK USB serial project

## Quick run

From repo root:

```bash
python3 lessons/L00-vscode-env/code/verify_env.py
```

## Pico SDK sample build (after SDK/toolchain setup)

```bash
cd lessons/L00-vscode-env/code/pico-sdk-usb-hello
mkdir -p build
cd build
cmake .. -DPICO_BOARD=<YOUR_BOARD_ID>
cmake --build .
```

If CMake fails with `PICO_SDK_PATH is not set`, export that environment variable first.
