# Assignment 13.1

import xml.etree.ElementTree as ET
import urllib.request, urllib.error, urllib.parse
from urllib.request import urlopen

url = input("Enter location:")
print("Retrieving:", url)
datastring = urlopen(url).read()
stuff = ET.fromstring(datastring)
lst = stuff.findall('comments/comment')

Tot = 0
for num in lst:
    n = int(num.find('count').text)
    Tot = Tot + n
    
print(Tot)