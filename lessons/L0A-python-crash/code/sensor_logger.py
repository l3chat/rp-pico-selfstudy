"""L0A mini practice: fake sensor logger with range checks."""


def classify_temperature(celsius):
    """Return a simple status string for a temperature value."""
    if celsius < 18:
        return "too low"
    if celsius > 30:
        return "too high"
    return "ok"


def average(values):
    """Return average of a non-empty list."""
    return sum(values) / len(values)


readings_c = [22.1, 23.4, 24.0, 25.6, 26.2]

for index, reading in enumerate(readings_c, start=1):
    status = classify_temperature(reading)
    print(f"reading {index}: {reading:.1f} C -> {status}")

print(f"summary: count={len(readings_c)}, avg={average(readings_c):.2f} C")