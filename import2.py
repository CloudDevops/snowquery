#!/usr/bin/python
import sys

# print sys.argv[1]

import json


with open(sys.argv[1]) as json_data:
    data = json.load(json_data)
    for r in data['result']:
        print r['name'],
