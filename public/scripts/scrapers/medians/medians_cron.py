#!/usr/bin/env python
# 
# Imports median json information to database
#

import couchdb
import medians
import sys

records = medians.load()

# Create database
couch = couchdb.Server()

if 'medians' in couch:
    del couch['medians']
db = couch.create('medians')

# Populate with a document per record
print 'Populating',len(records),'median records...'
db.update(records)
