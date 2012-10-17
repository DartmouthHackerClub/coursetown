#!/usr/bin/env python
import json
import urllib2
import lxml.html

ORC_URL = 'http://dartmouth.smartcatalogiq.com/2012/orc/Course-Descriptions-Undergraduate'

def fetch_courses(courses_url):
    courses_url = 'http://dartmouth.smartcatalogiq.com' + courses_url
    doc = lxml.html.parse(courses_url)
    for course in doc.xpath('//*[@id="main"]/ul/li/a'):
        yield course

def fetch_description(course_url):
    course_url = 'http://dartmouth.smartcatalogiq.com' + course_url
    response = urllib2.urlopen(course_url).read()
    doc = lxml.html.fromstring(response)
    return unicode(lxml.html.tostring(doc.cssselect('#main .desc')[0]), 'utf8', 'replace')

def main():
    result = {'courses': []}
    doc = lxml.html.parse(ORC_URL)
    for department in doc.xpath('//*[@id="main"]/ul/li/a'):
        for course in fetch_courses(department.attrib['href']):
            subject, number, title = course.text_content().split(u'\xa0', 2)
            description = fetch_description(course.attrib['href'])
            result['courses'].append({
                'subject': subject,
                'number': number,
                'title': title,
                'description': description
            })
    print json.dumps(result)

if __name__ == "__main__":
    main()
