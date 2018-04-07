# Assignment 9.4

name = input("Enter file:")
if len(name) < 1 : name = "mbox-short.txt"
handle = open(name)

counts = dict()

for line in handle:
    words = line.split()
    if len(words) < 1 or words[0] == "From:":
        continue
    elif words[0] == "From":
        counts[words[1]] = counts.get(words[1],0) + 1
        
bigname = None
bigcount = None
for key, value in counts.items():
    if bigcount is None or value > bigcount:
        bigcount = value
        bigname = key
        
print(bigname,bigcount)