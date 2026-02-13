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

## Serial monitor troubleshooting (Linux)

If `python3 -m serial.tools.miniterm ...` fails with `Permission denied` on `/dev/ttyACM*`:

1. Check device permissions:

   ```bash
   ls -l /dev/ttyACM0
   ```

2. Add your user to `dialout`:

   ```bash
   sudo usermod -aG dialout "$USER"
   ```

3. Log out and log back in, then reopen terminal/VS Code.
4. Verify the group is active:

   ```bash
   id
   ```

5. Retry `miniterm` without `sudo`.

If it still fails after relogin:

```bash
sudo fuser -v /dev/ttyACM0
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

If CMake fails with `PICO_SDK_PATH is not set`:

- export `PICO_SDK_PATH` in your shell, then rerun.
- or pass it directly:

```bash
cmake .. -GNinja -DPICO_BOARD=<YOUR_BOARD_ID> -DPICO_SDK_PATH="$HOME/opt/pico-sdk"
```

If CMake fails while downloading `picotool`:

- install `picotool` on your host.
- or for an offline compile check only, configure with `-DPICO_NO_PICOTOOL=1` (UF2 output will be disabled).

If VS Code shows an include error in `main.c` for `pico/stdlib.h`:

- run CMake configure once so `build/compile_commands.json` is generated.
- then run `C/C++: Rescan Workspace` in the VS Code command palette.
