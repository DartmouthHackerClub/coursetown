#!/usr/bin/python

#
# takes median json info from stdin and loads into courses
# this should be run every term
#

import couchdb
import sys
import json
import urllib
from couchdb.schema import Document

BOOTSTRAP = False

couch = couchdb.Server()

courses = couch['courses']
medians = couch['medians']

if BOOTSTRAP:
    print 'Bootstrapping...'
    # only need to run this once
    for course_id in courses:
        course = courses[course_id]
        course['avg_median'] = ''
        courses[course_id] = course
    sys.exit(1)

median_data = json.loads(sys.stdin.readline())['records']

def course_query(dept, num):
    return "function(doc) {\
    for (var i in doc.names)\
        if (doc.names[i].Department == '%s' && doc.names[i].Number == '%03d')\
          emit(doc._id, doc);}" % (dept, num)


def median_query(dept, num):
    return "function(doc) {\
        if (doc.dept == '%s' && doc.number == '%03d')\
          emit(doc._id, doc);}" % (dept, num)

def avg_median(dept, num):
    query_func = median_query(dept, num)

    total = 0.0
    num = 0
    for row in medians.query(query_func):
        val = row.value['median']
        if val == 'A': total+=4.0
        elif val == 'A-': total+=3.66
        elif val == 'B+': total+=3.33
        elif val == 'B': total+=3.0
        elif val == 'B-': total+=2.66
        elif val == 'C+': total+=2.33
        elif val == 'C': total+=2
        elif val == 'C-': total+=1.66
        else: continue
        num += 1

    if num == 0:
        return None
    return (total/num)


ok = False
c = 0
total = len(median_data)
# classes show up possibly multiple times per term, usually at least once per year.
# cache so we only need to calculate average median once
cache = {}
for course in median_data:
    c += 1
    dept = course['dept']
    try:
        num = int(float((course['number'])))
    except:
        print 'Error on:'
        print course
        continue

    """
    if c == 3122:
        ok = True
    if not ok:
        continue
        """

    key = dept + ':' + str(num)

    print '(%d/%d) Finding avg median for %s %s' % (c, total, dept, num)
    if not key in cache:
        cache[key] = avg_median(dept, num)

    avg = cache[key]
    print '(%d/%d) Updating %s %s with median "%s"' % (c, total, dept, num, avg if avg else 'n/a')
    query_func = course_query(dept, num)
    for row in courses.query(query_func):
        row.value['avg_median'] = avg if avg else ''
        courses[row.key] = row.value
