#!/usr/bin/env python
# 
# Imports orc json information to database
#

import couchdb
import orc

print 'Loading ORC records...'
records = orc.load()

print 'Checking/creating database...'
# Create database
couch = couchdb.Server()

if 'orc' in couch:
    del couch['orc']
db = couch.create('orc')

# Populate with a document per record
print 'Populating ORC records...'
db.update(records)
