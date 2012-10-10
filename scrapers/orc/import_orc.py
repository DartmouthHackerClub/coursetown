#!/usr/bin/python

# takes json from stdin and loads into orc table

import couchdb
import sys
import json
from couchdb.schema import Document

BOOTSTRAP = False

couch = couchdb.Server()

courses = couch['courses']

if BOOTSTRAP:
    print 'Bootstrapping'
    # only need to run this once
    for course_id in courses:
        course = courses[course_id]
        course['description'] = ''
        course['offered'] = ''
        course['note'] = ''
        courses[course_id] = course

    sys.exit(1)

orc_data = json.loads(sys.stdin.readline())

def dept_query(dept):
    return "function(doc) {\
    for (var i in doc.names)\
        if (doc.names[i].Department == '%s')\
          emit(doc._id, doc);}" % dept

def course_query(dept, num):
    return "function(doc) {\
    for (var i in doc.names)\
        if (doc.names[i].Department == '%s' && doc.names[i].Number == '%03d')\
          emit(doc._id, doc);}" % (dept, num)


for course in orc_data['courses']:
    dept = course['subject']
    try:
        num = int(float((course['number'])))
    except:
        print 'Error on:'
        print course
        continue

    note = course['note']
    print 'Updating %s %s' % (dept, num)
    query_func = course_query(dept, num)
    for row in courses.query(query_func):
        row.value['description'] = course['description'] if 'description' in course else ''
        row.value['note'] = course['note'] if 'note' in course and course['note'] else ''
        row.value['offered'] = course['offered'] if 'offered' in course else ''
        courses[row.key] = row.value
