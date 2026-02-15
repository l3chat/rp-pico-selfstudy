"""L0A step 3: Conditionals and loops."""

temperature_c = 26.5

if temperature_c < 18:
    print("Status: too cold")
elif temperature_c <= 30:
    print("Status: ok")
else:
    print("Status: too hot")

print("For loop demo:")
for i in range(5):
    print("  count", i)

print("While loop demo:")
count = 0
while count < 3:
    print("  while", count)
    count += 1