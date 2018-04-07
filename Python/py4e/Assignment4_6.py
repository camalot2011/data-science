#Assignment 4.6

def computepay(h,r):
    h_f = float(h)
    r_f = float(r)
    if h_f <= 40:
        pay = h_f * r_f
    else:
        pay = 40 * r_f + (h_f-40) * r_f * 1.5
    return pay

hrs = input("Enter Hours:")
rate = input("Enter Rate:")
p = computepay(hrs,rate)
print(p)