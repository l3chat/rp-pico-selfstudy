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

## MicroPython smoke test (L00)

File:

- `micropython/hello_repl.py`

MicroPython UF2 download pages:

- index: `https://micropython.org/download/`
- Pico (RP2040): `https://micropython.org/download/RPI_PICO/`
- Pico 2 (RP2350): `https://micropython.org/download/RPI_PICO2/`

Flash the UF2 before running the smoke test:

1. Hold `BOOTSEL` while plugging in USB.
2. Copy the `.uf2` file to the `RPI-RP2` drive.
3. Wait for the board to reboot.
4. Open serial monitor again.

If you use RP2040-Zero or RP2350-Zero:

- there is not always a dedicated official MicroPython download page for Zero board names.
- use the chip-family pages above first (`RPI_PICO` for RP2040, `RPI_PICO2` for RP2350).
- then verify board-specific UF2 guidance from the board vendor docs.

Behavior:

- prints `L00 MicroPython smoke test starting` once
- prints `tick 0`, `tick 1`, `tick 2`, ... once per second
- uses no LED pin so it stays board-neutral

Run options:

- paste into REPL and run directly
- or upload as `main.py` on a MicroPython board and reset

Expected observable result:

- startup line appears once
- then `tick` lines continue every second on serial output

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
