#!/usr/bin/env python
import re
import sys
import json
import urllib2
import lxml.html

ORC_URL = 'http://dartmouth.smartcatalogiq.com/en/2013/orc/Departments-Programs-Undergraduate'

def absolute(url):
    return 'http://dartmouth.smartcatalogiq.com' + url

def fetch_courses(dept_url):
    dept_url = absolute(dept_url)
    response = urllib2.urlopen(dept_url).read()
    doc = lxml.html.fromstring(response)
    for link in doc.cssselect('#main em'):
        if re.match('To view .* courses, click here\.', link.text_content()):
            courses_url = absolute(link.cssselect('a')[0].attrib['href'])
            courses_doc = lxml.html.parse(courses_url)
            for course in courses_doc.xpath('//*[@id="main"]/ul/li/a'):
                yield course

def fetch_description(course_url):
    course_url = absolute(course_url)
    response = urllib2.urlopen(course_url).read()
    doc = lxml.html.fromstring(response)
    return unicode(lxml.html.tostring(doc.cssselect('#main .desc')[0]), 'utf8', 'replace')

def main():
    result = {'courses': []}
    doc = lxml.html.parse(ORC_URL)
    for department in doc.xpath('//*[@id="sc-programlinks"]/ul/li/p/a'):
        for course in fetch_courses(department.attrib['href']):
            subject, number, title = course.text_content().split(u'\xa0', 2)
            try:
                description = fetch_description(course.attrib['href'])
            except:
                print >> sys.stderr, "failed to fetch", absolute(course.attrib['href'])
                continue
            result['courses'].append({
                'subject': subject,
                'number': number,
                'title': title,
                'description': description
            })
    print json.dumps(result)

if __name__ == "__main__":
    main()
