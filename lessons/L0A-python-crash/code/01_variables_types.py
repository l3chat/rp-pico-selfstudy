"""L0A step 1: Variables and data types."""

board_name = "RP2040 or RP2350 board"
attempt_count = 3
voltage = 3.3
setup_ok = True

print("Board:", board_name)
print("Attempts:", attempt_count)
print("Voltage:", voltage)
print("Setup ok:", setup_ok)

print("Type of attempt_count:", type(attempt_count).__name__)
print("Type of voltage:", type(voltage).__name__)
print("Type of board_name:", type(board_name).__name__)
print("Type of setup_ok:", type(setup_ok).__name__)