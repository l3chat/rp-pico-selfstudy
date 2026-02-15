"""L0A step 4: Functions and return values."""


def c_to_f(celsius):
    """Convert Celsius to Fahrenheit."""
    return (celsius * 9 / 5) + 32


def make_status(label, value):
    """Format a status line."""
    return f"{label}: {value}"


reading = 24.0
reading_f = c_to_f(reading)

print(make_status("Reading C", reading))
print(make_status("Reading F", round(reading_f, 2)))