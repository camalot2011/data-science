# Assignment5.2

largest = None
smallest = None
while True:
    num = input("Enter a number: ")
    try:
        n = int(num)
    except:
        if num == "done" : 
            break
        else:
            print("Invalid input")
            continue
    if smallest is None: 
        largest = n
        smallest = n
    if n<=smallest: 
        smallest = n
    elif n>=largest: 
        largest = n
    else : 
        continue
    
        
print("Maximum is", largest)
print("Minimum is", smallest)