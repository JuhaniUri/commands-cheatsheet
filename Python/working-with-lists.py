# List and loop
v_towns = ['london', 'tallinn', 'helsinki', 'tartu']
for town in v_towns:
    print(town.title())

# Line break between examples
print('\n')

# Adding text
v_towns = ['london', 'tallinn', 'helsinki', 'tartu']
for town in v_towns:
    print(town.title() + " is in Europa")
    print("Town called " + town.title() + " is located in Europa \n")
print("This is an end of loop\n")

# Numerical lists
# Will print number from 1-4. Python will start from first number and stops at the second value.
print("Let's play with numbers in list")
for value in range(1,5):
    print(value)
print("Print 1-5")
for value in range(1,6):
    print(value)

# Number an values
print("list of numbers")
v_numbers = list(range(1,6))
print(v_numbers)

# Number an values - now even
# First number, where to start, second number stop and third one how much will be added
# so in case we will start with even, then range will be even
print("list of numbers")
v_numbers_even = list(range(2,12,2))
print(v_numbers_even)
# Let start with odd
print("list of numbers")
v_numbers_odd = list(range(1,12,2))
print(v_numbers_odd)
