# Assignment 13.3

import urllib.request, urllib.error, urllib.parse
from urllib.request import urlopen
import json

serviceurl = "http://py4e-data.dr-chuck.net/geojson?"

address = input("Enter location:")
url = serviceurl + urllib.parse.urlencode({"address": address})

print("Retrieving:", url)
data = urlopen(url).read()
print("Retrieved", len(data),"characters")

try:
    js = json.loads(data)
except:
    js = None
    
if not js or "status" not in js or js["status"] != "OK":
    print("Retrieving is failed")
    
place_id = js["results"][0]["place_id"]
print(place_id)