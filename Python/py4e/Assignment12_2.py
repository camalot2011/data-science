# Assignment 12.2

import urllib.request, urllib.parse, urllib.error
from urllib.request import urlopen
from bs4 import BeautifulSoup
import ssl
import re

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

url = input("Enter - ")
html = urlopen(url, context=ctx).read()

soup = BeautifulSoup(html,"html.parser")

Tot = 0
tags = soup("span")
for tag in tags:
    Tot = Tot + int(tag.contents[0])
    
print(Tot)
            