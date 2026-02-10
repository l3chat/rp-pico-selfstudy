"""MicroPython sanity check script for lesson L00."""

from time import sleep

print("L00 MicroPython hello")
print("If you can read this, upload + serial output are working.")

for tick in range(5):
    print(f"tick: {tick}")
    sleep(1)

print("done")
