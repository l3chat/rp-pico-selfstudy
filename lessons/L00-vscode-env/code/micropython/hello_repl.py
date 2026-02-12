"""MicroPython serial smoke test for L00.

Paste or upload this script to a board running MicroPython.
It prints a heartbeat counter once per second.
"""

import time

print("L00 MicroPython smoke test starting")
count = 0

while True:
    print("tick", count)
    count += 1
    time.sleep(1)
