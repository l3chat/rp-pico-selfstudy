# L00 Code Assets

This folder contains minimal runnable examples used in lesson L00.

## Files

- `verify_env.py` — checks host tools, Python packages, `PICO_SDK_PATH`, and VS Code extensions
- `micropython/hello_repl.py` — serial heartbeat script for MicroPython
- `pico-sdk-usb-hello/` — minimal Pico SDK USB serial project

## Quick run

From repo root:

```bash
python3 lessons/L00-vscode-env/code/verify_env.py
```

## Pico SDK install (Linux quick path)

```bash
sudo apt update
sudo apt install -y cmake gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib ninja-build
mkdir -p "$HOME/opt"
cd "$HOME/opt"
git clone https://github.com/raspberrypi/pico-sdk.git
git -C pico-sdk submodule update --init
echo 'export PICO_SDK_PATH="$HOME/opt/pico-sdk"' >> ~/.bashrc
source ~/.bashrc
test -f "$PICO_SDK_PATH/external/pico_sdk_import.cmake" && echo "PICO_SDK_PATH OK"
```

If you are on macOS/Windows, use:

- `https://www.raspberrypi.com/documentation/microcontrollers/c_sdk.html`
- `https://github.com/raspberrypi/pico-setup`

## Pico SDK sample build (after SDK/toolchain setup)

```bash
cd lessons/L00-vscode-env/code/pico-sdk-usb-hello
mkdir -p build
cd build
cmake .. -GNinja -DPICO_BOARD=<YOUR_BOARD_ID>
cmake --build .
```

If CMake fails with `PICO_SDK_PATH is not set`, export that environment variable first.
