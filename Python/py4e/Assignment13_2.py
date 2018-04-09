# Assignment 13.2

import urllib.request,urllib.parse,urllib.error
from urllib.request import urlopen
import json

url = input("Enter location:")
data = urlopen(url).read()
print("Retrieving:",url)
info = json.loads(data)

count = 0
for item in info["comments"]:
    num = item["count"]
    count = count + int(num)
    
print(count)