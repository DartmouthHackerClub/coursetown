#!/usr/bin/env python
# 
# Imports orc json information to database
#

import couchdb
import json

print 'Loading ORC records...'
f = open('course_set.json')
j = json.loads(f.read())
f.close()

courses = j['courses']

print 'Checking/creating database...'
# Create database
couch = couchdb.Server()

if 'orc' in couch:
    del couch['orc']
db = couch.create('orc')

# Populate with a document per record
print 'Populating ORC records...'
db.update(j['courses'])
