# Working with list

# List as variable
from audioop import reverse


v_cars = ['audi', 'bmw', 'skoda', 'subaru', 'vw']

# Whole list
print(v_cars)

# First from the list
print(v_cars[0])

# Last from the list
print(v_cars[-1])

# With Capitals
print(v_cars[0].title())

# Compine into message
v_message = "My first car was a " + v_cars[0].title() + "."
print(v_message)



# Modify list
v_cars[0] = 'volvo'
# Whole list
print(v_cars)

# Adding to list
v_cars.append('opel')
# Whole list
print(v_cars)

# Removing from list
del v_cars[0]
# Whole list
print(v_cars)

# Remove using pop() method
v_cars_popped_last = v_cars.pop()
# Last record was moved from list and set as v_cars.pop value. It's like cut if are using it togheter with variable as bellow
print(v_cars)
print(v_cars_popped_last)
v_message = "My last car was a " + v_cars_popped_last.title() + "."
print(v_message)

# We can use index mehtod
v_cars_popped_index = v_cars.pop(0)
print(v_cars)
print(v_cars_popped_index)


# Removing an item by Value
print(v_cars)
v_cars.remove('subaru')
print(v_cars)

# Another removal example
print('\nReset list ')
v_cars = ['audi', 'bmw', 'subaru', 'vw','skoda']
print(v_cars)
v_damaged_car = 'subaru'
v_cars.remove(v_damaged_car)
print("\nA " + v_damaged_car.title() + " was damaged.")
print(v_cars)

# Organizing a list
# sort() method
print("\n Unsorted List")
print(v_cars)
v_cars.sort()
print("\n Sorted list")
print(v_cars)
# Sort in reverse
v_cars.sort(reverse=True)
print("\n Reverse sorted list")
print(v_cars)

# temp sort with sorted()
print("\n Original list")
print(v_cars)

print("\n Here comes the list")
print(sorted(v_cars))

print("\n Again the original list")
print(v_cars)

# Sort in reverse with function reverse()
v_cars.reverse()
print("\n reverse with function list")
print(v_cars)

# Lengh of a list
v_cars = ['audi', 'bmw', 'subaru', 'vw','skoda']
print(v_cars)
v_length=len(v_cars)
print("\n Print lengh of the list")
print(v_length)
