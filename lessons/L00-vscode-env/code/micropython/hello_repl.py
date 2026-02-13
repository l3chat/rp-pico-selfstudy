"""MicroPython serial smoke test for L00.

Paste or upload this script to a board running MicroPython.
It prints one startup line, then a heartbeat counter once per second.
If you paste in REPL, use Ctrl+E (paste mode), then Ctrl+D to run.
In REPL mode, stop it with Ctrl+C.
"""

import time

print("L00 MicroPython smoke test starting")
count = 0

while True:
    print("tick", count)
    count += 1
    time.sleep(1)
