# L0A - Assessment

## Navigation

- [Lesson overview](overview.md)
- [Code assets README](code/README.md)

Source files for this assessment:

- [`code/01_variables_types.py`](code/01_variables_types.py)
- [`code/02_conditionals_loops.py`](code/02_conditionals_loops.py)
- [`code/03_functions_modules.py`](code/03_functions_modules.py)
- [`code/sensor_logger.py`](code/sensor_logger.py)

## How to use this assessment

- Time budget: 15 minutes
- Do not search online first. Answer from memory.
- Then run the practical task and self-grade with the rubric.

## Quiz (short self-check)

1. What is the difference between `int`, `float`, and `str` in Python?
2. What does this line do: `for i in range(3):`?
3. When should you use `if/elif/else`?
4. What is the purpose of a function `return` value?
5. What common issue causes `NameError`?
6. What command runs this file from repo root: `lessons/L0A-python-crash/code/sensor_logger.py`?

## Practical task

Complete this workflow without skipping steps:

1. Run all four practice files:

   ```bash
   python3 lessons/L0A-python-crash/code/01_variables_types.py
   python3 lessons/L0A-python-crash/code/02_conditionals_loops.py
   python3 lessons/L0A-python-crash/code/03_functions_modules.py
   python3 lessons/L0A-python-crash/code/sensor_logger.py
   ```

2. Create a small local note file at `lessons/L0A-python-crash/code/my_l0a_notes.txt` with four lines:

  - one example `int` value you used
  - one `if` condition in plain English
  - one reason functions are useful
  - one command you will reuse in L01

3. Modify `sensor_logger.py` so one reading is out of range, then run it again.

Expected result:

- at least one status line prints `too low` or `too high`.

## Rubric (self-grading)

Score each item as 0 or 1.

- [ ] I ran each L0A practice script from terminal.
- [ ] I can explain the four basic types (`int`, `float`, `str`, `bool`).
- [ ] I can read and explain one `if/elif/else` block.
- [ ] I can read and explain one `for` loop and one `while` loop.
- [ ] I can define and call a function with parameters.
- [ ] I understand what `return` gives back to the caller.
- [ ] I created `my_l0a_notes.txt` with all four required lines.
- [ ] I modified `sensor_logger.py` and observed an out-of-range status.

Scoring:

- 8/8: ready for L0B.
- 6-7/8: continue, but keep L0A open as reference.
- 0-5/8: repeat L0A guided steps before continuing.

## Answer key / hints

1. `int` is whole numbers, `float` is decimal numbers, `str` is text.
2. It repeats a block three times with `i` values 0, 1, 2.
3. Use it to choose one path based on conditions.
4. `return` sends a value from a function back to where it was called.
5. Name spelling or case mismatch (for example `Count` vs `count`).
6. `python3 lessons/L0A-python-crash/code/sensor_logger.py`