#!/usr/bin/python

import couchdb
import json
import sys

saveme = json.loads(sys.stdin.readline())

couch = couchdb.Server()

if not 'dept_abbrevs' in couch:
    couch.create('dept_abbrevs')

db = couch['dept_abbrevs']

if db.get('latest'):
    db.delete(db['latest'])

db['latest'] = saveme
