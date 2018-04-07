# Assignment 11

fname = input("Enter the file:")
if len(fname) < 1: fname = "regex_sum_42.txt"
handle = open(fname)

Tot = 0
import re
for line in handle:
    if len(line.strip()) < 1: continue
    num = re.findall('[0-9]+',line)
    for n in num:
        Tot = Tot + int(n)
    
print(Tot)