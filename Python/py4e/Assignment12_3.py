# Assignment 12.3

import urllib.request, urllib.parse, urllib.error
from urllib.request import urlopen
from bs4 import BeautifulSoup
import ssl
import re

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

url = input("Enter - ")
count = input("Enter count:")
position = input("Enter position:")

for c in range(int(count)+1):
    html = urlopen(url, context=ctx).read()
    soup = BeautifulSoup(html,"html.parser")
    tags = soup("a")
    print("Retriving:",url)
    p = 0
    for tag in tags:
        if p < (int(position)-1): 
            p = p + 1
            continue
        else: 
            url = tag.get("href",None)
            break
        