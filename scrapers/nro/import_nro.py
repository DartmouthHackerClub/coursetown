#!/usr/bin/python

# takes json from stdin and loads into nro table

import couchdb
import sys
import json
import course
from couchdb.schema import Document

couch = couchdb.Server()

nro_data = json.loads(sys.stdin.readline())

courses = couch['courses']

# only need to run this once
#for course_id in courses:
#    course = courses[course_id]
#    course['nro'] = 'true'
#    courses[course_id] = course

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


for no_nro in nro_data:
    dept = no_nro['department']
    nums = no_nro['courses']
#    print dept, nums
    if nums == 'all':
        query_func = dept_query(dept)
#        print query_func
        for row in courses.query(query_func):
#            print row.key, row.value
            row.value['nro'] = 'false'
            courses[row.key] = row.value
#            print courses[row.key]
        
    else:
        for num in nums:
            query_func = course_query(dept, num)
#            print query_func
            for row in courses.query(query_func):
#                print row.key, row.value
                row.value['nro'] = 'false'
                courses[row.key] = row.value
#                print courses[row.key]
