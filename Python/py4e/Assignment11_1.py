# Assignment 11.1

fname = input("Enter the file:")
if len(fname) < 1: fname = "regex_sum_42.txt"
handle = open(fname)

import re
print(sum([int(n) for n in re.findall('[0-9]+',handle.read())]))