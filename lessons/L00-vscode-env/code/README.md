# L00 Code Bundle

This folder contains minimal examples used in lesson L00.

## Files
- `env_check.py` - checks whether required/optional host tools are available.
- `micropython_hello.py` - simple script to run on MicroPython via `mpremote`.
- `pico_sdk_hello/` - minimal Pico SDK C project that builds a UF2.

## Quick start

Run environment check:

```bash
python3 env_check.py
python3 env_check.py --strict
```

If `python3` is not recognized, use `python` or `py -3`.

Run MicroPython sample (board connected):

```bash
mpremote connect auto run micropython_hello.py
```

Build Pico SDK sample:

```bash
cd pico_sdk_hello
cmake -S . -B build -G Ninja
cmake --build build
```

Expected build artifact:
- `pico_sdk_hello/build/l00_pico_sdk_hello.uf2`
