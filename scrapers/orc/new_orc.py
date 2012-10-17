#!/usr/bin/env python
import urllib2
import lxml.html

ORC_URL = 'http://dartmouth.smartcatalogiq.com/2012/orc/Course-Descriptions-Undergraduate'

def fetch_courses(courses_url):
    courses_url = 'http://dartmouth.smartcatalogiq.com' + courses_url
    doc = lxml.html.parse(courses_url)
    for course in doc.xpath('//*[@id="main"]/ul/li/a'):
        yield course

def fetch_course(course_url):
    course_url = 'http://dartmouth.smartcatalogiq.com' + course_url
    response = urllib2.urlopen(course_url).read()
    doc = lxml.html.fromstring(response)
    description = unicode(lxml.html.tostring(doc.cssselect('#main .desc')[0]), 'utf8', 'replace')
    try:
        instructors = doc.cssselect('#instructor')[0].text_content().replace('Instructor', '').split(', ')
        instructors = [unicode(s.strip(), 'utf8', 'replace') for s in instructors]
    except:
        instructors = None
    try:
        distributive = doc.cssselect('#distribution')[0].text_content().replace('Distributive', '').split('; ')
        distributive = [unicode(s.strip(), 'utf8', 'replace') for s in distributive]
    except:
        distributive = None
    try:
        offered = unicode(doc.cssselect('#offered')[0].text_content().replace('Offered', ''), 'utf8', 'replace')
    except:
        offered = None
    return description, instructors, distributive, offered

def main():
    doc = lxml.html.parse(ORC_URL)
    for department in doc.xpath('//*[@id="main"]/ul/li/a'):
        print "FETCHING", department.text_content()
        for course in fetch_courses(department.attrib['href']):
            print "FETCHING", course.text_content()
            desc, instructors, dist, offered = fetch_course(course.attrib['href'])
            print desc
            print instructors, dist, offered

if __name__ == "__main__":
    main()
