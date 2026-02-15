# L0A - Python Crash Course (for MicroPython + tooling) (90 minutes)

## Outcome (what you will have at the end)

By the end of this lesson, you will have:

- a beginner-level mental model of Python variables, conditionals, loops, and functions
- confidence running Python files from the terminal
- practice reading and fixing common beginner errors
- a tiny text-based "sensor logger" script that prepares you for MicroPython lessons

## Prerequisites

- Completed L00 environment setup
- Python 3 available in your terminal (`python3` or `python`)

## Navigation

Lesson sections:

- [Step 1: Confirm Python works](#step-1-confirm-python-works)
- [Step 2: Variables and data types](#step-2-variables-and-data-types)
- [Step 3: Conditionals and loops](#step-3-conditionals-and-loops)
- [Step 4: Functions and simple modules](#step-4-functions-and-simple-modules)
- [Step 5: Build mini practice script](#step-5-build-mini-practice-script)
- [Assessment](assessment.md)

Source files used in this lesson:

- [`code/README.md`](code/README.md)
- [`code/01_variables_types.py`](code/01_variables_types.py)
- [`code/02_conditionals_loops.py`](code/02_conditionals_loops.py)
- [`code/03_functions_modules.py`](code/03_functions_modules.py)
- [`code/sensor_logger.py`](code/sensor_logger.py)

## Time plan (90 minutes)

- 0-10 min: orientation
- 10-25 min: Python run/check basics + variables/types
- 25-45 min: conditionals and loops
- 45-65 min: functions and modules
- 65-75 min: explain-it-back
- 75-90 min: assessment

## 0-10 min: Orientation

### Why this lesson exists

MicroPython is still Python. Before touching GPIO or sensors, you need the language basics so you can read, modify, and debug scripts with less friction.

### Checkpoint

- [ ] You can explain the difference between:
  - running Python on your computer (`python3 file.py`)
  - running MicroPython on the board (through serial/REPL or uploaded script)

If you cannot explain this yet:

- pause and describe it in one sentence before continuing.

## 10-25 min: Variables and data types

### Step 1: Confirm Python works

Run:

```bash
python3 --version
```

Expected result:

- you see a Python version line (for example `Python 3.11.x`).

If `python3` is not found:

- try `python --version`.

Run the first practice file:

```bash
python3 lessons/L0A-python-crash/code/01_variables_types.py
```

Expected result:

- output lines that show number, text, and boolean examples.

If you see `SyntaxError`:

- make sure you did not edit the file accidentally.

### Step 2: Variables and data types

Open:

- [`code/01_variables_types.py`](code/01_variables_types.py)

Focus points:

- variable assignment (`=`) stores a value
- common beginner types:
  - `int` (whole number)
  - `float` (decimal number)
  - `str` (text)
  - `bool` (`True` / `False`)

Checkpoint:

- [ ] You can change one variable and predict one output line before running.

## 25-45 min: Conditionals and loops

### Step 3: Conditionals and loops

Run:

```bash
python3 lessons/L0A-python-crash/code/02_conditionals_loops.py
```

Expected result:

- a status line from an `if/elif/else` decision
- loop output that counts through values

If output is too fast to read:

- add `input("Press Enter to continue...")` at the end, rerun, and inspect step by step.

Concept checklist:

- [ ] I know `if` chooses one branch.
- [ ] I know `for` loops over a sequence (`range(...)`).
- [ ] I know `while` repeats while a condition is true.

## 45-65 min: Functions and simple modules

### Step 4: Functions and simple modules

Run:

```bash
python3 lessons/L0A-python-crash/code/03_functions_modules.py
```

Expected result:

- output from function calls with parameters and return values.

Open:

- [`code/03_functions_modules.py`](code/03_functions_modules.py)

Focus points:

- define with `def`
- call with arguments
- use `return` to send a value back

If you see `NameError`:

- check spelling of function names and variable names (case matters).

## 65-75 min: Explain it back

Answer in your own words:

1. Why do we use functions instead of repeating copy-pasted code?
2. What is the difference between `for` and `while` loops?
3. What does a `return` value do?

## 75-90 min: Build mini practice script

### Step 5: Build mini practice script

Run:

```bash
python3 lessons/L0A-python-crash/code/sensor_logger.py
```

What this script simulates:

- fake temperature readings in a list
- range checks (`too low`, `ok`, `too high`)
- summary output (average and count)

Expected result:

- multiple reading lines followed by a summary line.

If you see `ModuleNotFoundError`:

- run from repo root exactly as shown above.

Final checklist for L0A:

- [ ] I can run Python scripts from terminal.
- [ ] I can explain `int`, `float`, `str`, `bool`.
- [ ] I can write a basic `if` statement.
- [ ] I can write a `for` loop with `range`.
- [ ] I can define and call a function with `return`.
- [ ] I completed the mini practice script.

Proceed to [`assessment.md`](assessment.md).