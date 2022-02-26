# Working with list

# List as variable
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



#
# Modify list
v_cars[0] = 'volvo'
# Whole list
print(v_cars)

# Adding to list
v_cars.append('opel')
# Whole list
print(v_cars)


