# List and loop
from numpy import square


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


# Squares
v_squares=[]
for value in range(1,11):
    v_square = value**2
    v_squares.append(v_square)

print(v_squares)

# Squares mode advaced 
v_squares = [value**2 for value in range(1,11)]
print(v_squares)

# Some simple statistics with list of numbers
v_digits = [1,2,3,4,5,6,7,8,9,0]
print(min(v_digits))
print(max(v_digits))
print(sum(v_digits))


# Slicing a list

v_drinks = ['coffee', 'beer', 'wine', 'vodka', 'water', 'coca-cola']
print(v_drinks[0:3])
print(v_drinks[1:3])
print(v_drinks[:3])
print(v_drinks[3:])

# Loop and slice
print('My favorite drinks are:')
for drink in v_drinks[1:3]:
    print(drink.title())

# Copying a list
v_drinks = ['coffee', 'beer', 'wine', 'vodka', 'water', 'coca-cola']
v_friends_drinks = v_drinks[:]

v_drinks.append('rum')
v_friends_drinks.append('cider')

print('My favorite drinks are:')
print(v_drinks)

print('Friends favorite drinks are:')
print(v_friends_drinks)

# Tuples
# Python refers to values that cannot change as immutable, and an immutable list is called a tuple.
# A Tuple look like a list execpt you use parentheses () instead of square brackets [].
# When compared with lists, tuples are simple data structutes. 
v_dimensions = (200, 50)
print(v_dimensions[0])
print(v_dimensions[1])

# Looping and tuple, same case as for lists
for dimension in v_dimensions:
    print(dimension)

# Writing over a Tuple
v_dimensions = (400, 110)

# Looping and tuple, same case as for lists
for dimension in v_dimensions:
    print(dimension)

