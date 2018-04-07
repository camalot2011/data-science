# Assignment 10.2

fname = input("Enter the file:")
if len(fname) < 1: fname = "mbox-short.txt"
handle = open(fname)

count = dict()

for line in handle:
    if line.startswith("From:"): continue
    elif line.startswith("From"):
        words = line.split()
        time = words[5].split(":")
        hour = time[0]
        count[hour] = count.get(hour,0) + 1

for h,n in sorted(count.items()):
    print(h,n)