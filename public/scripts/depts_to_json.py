#!/usr/bin/env python

import json

f = open('dept_map.csv')
lines = f.readlines()
f.close()

d = {}
for line in lines:
    line = line.replace('"', '').replace('\n','')
    s = line.split(';')
    if s[0] == '???':
        continue
    d[s[0]] = dict(id=s[1], name=s[2])
    
print json.dumps(d)
