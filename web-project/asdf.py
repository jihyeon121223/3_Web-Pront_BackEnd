import requests
from urllib import parse
import pandas as pd
from bs4 import BeautifulSoup
from datetime import datetime

url = 'http://apis.data.go.kr/B552584/EvCharger/getChargerInfo?serviceKey'
params ={'serviceKey' : 'blria7TY6VCPbn8QUgYrHz5RNNYWej29+Halh6YgL1DzuZApx70h2jqf9Y3bMDXQcfleL1v/l548DEzZXKMSWg==', 'type':'xml', 'numOfRows' : '10', 'pageNo' : '1' }

response = requests.get(url, params=params)
xml = BeautifulSoup(response.text, "lxml")
items = xml.find("items")
item_list = []
for item in items:
    item_dict = {
            'statnm': item.find("statnm").text.strip(),
            'chgertype': int(item.find("chgertype").text),
            'addr': item.find("addr").text.strip(),
            'lat': float(item.find("lat").text),
            'lng': float(item.find("lng").text),
            'usetime': item.find("usetime").text.strip(),
            'businm': item.find("businm").text.strip(),
            'busicall': item.find("busicall").text.strip(),
            'stat': int(item.find("stat").text),
            # "statupdatedatetime": datetime.strptime(item.find("statupdatedatetime").text.strip(), '%Y-%m-%d %H:%M:%S')
            'statupddt': int(item.find("statupddt").text),
            'parkingfree': item.find("parkingfree").text.strip() 
    }
    item_list.append(item_dict)

df = pd.DataFrame(item_list)

print(df)