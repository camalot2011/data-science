
hrs = input("Enter Hours:")
h = float(hrs)
rate = input("Enter Rate:")
if h <= 40:
    pay = h * float(rate)
else:
    pay = 40 * float(rate) + (h-40) * float(rate) * 1.5
print(pay)