#!/usr/bin/env python
#
# Takes html containing medians table in, spits out JSON.  Uses the popular
# HTML parsing library BeautifulSoup.
#
# Now works for the formats used from 08F - 11W.
#

import sys
import re
import urllib
import json
from BeautifulSoup import BeautifulSoup
import traceback

# Parse the department, course number and section number from a course
# listing.  Supports 08F - 11W.
# Regex explanation:
#   '[A-Z&]{3,4}' - Dept. is generally 4 chars, but a few have 3 or an &
#   ' ?'          - There might be a space, if the dept. is only 3 chars
#   '-?'          - Some formats have a dash between the dept and course number
#   '[\d]{3}'     - Course number is always 3 digits
#   '-?'          - Some formats have a dash between the course number and section
#   '[\d]{2}'     - Section number is always 2 digits
def parse_course(course):
    course_clean = re.sub('&amp;', '&', course)
    info = re.search('([A-Z&]{3,4}) ?-?([\d]{3})-?([\d]{2})', course_clean)
    if info:
        dept = info.group(1)
        number = int(info.group(2))
        section = int(info.group(3))
        return (dept, number, section)
    else:
        return None

# Remove some oddities from the median listing
# Note: commented out code to eliminate the space in some median listings to
# conform with the old script's output, although we might want to remove
# the space.
def clean_median(median):
    # Some of the pages use a lot of &nbsp; to increase the median td length
    nonbsp = re.sub('&nbsp;', '', median)
    
    # For some reason, the new format has a space after 'A' in 'A /A-',
    # so remove it
    # nospace = re.sub(' ', '', nonbsp)
    
    return nonbsp

# Returns a list of the stripped contents of all <td>'s inside the given
# <tr>.
def get_td_contents(tr):
    td = tr.findAll('td')
    if td:
        # Some formats put the strings in a <p> inside of the <td>, so
        # check for that
        if td[0].p:
            return [i.p.string.strip() for i in td]
        else:
            return [i.string.strip() for i in td]
    
    return None

# Find the listed median pages, download and parse the data, and return a
# list of dicts, one for each median listing.
def load():
    data = urllib.urlopen('http://www.dartmouth.edu/~reg/courses/medians/').read()

    # Find links to individual median pages
    urls = re.findall(r'http://www\.dartmouth\.edu/~reg/courses/medians/.*?\.html', data)

    if not urls:
        print "Couldn't urls any median pages in input"
        sys.exit(1)

    l = []
    for url in urls:
        data = urllib.urlopen(url).read()
        soup = BeautifulSoup(data)
        # Remove first tr, which is the table header
        hdr = soup.find('tr')
        hdr.extract()
        # Iterate through the rest of the tr's
        for tr in soup.findAll('tr'):
            try:
                td = tr.findAll('td')
                td_contents = get_td_contents(tr)
                (dept, number, section) = parse_course(td_contents[1])
            except Exception as e:
                # Simple debug printing
                # traceback.print_exc()
                # print tr
                continue
            else:
                # Fill the dictionary with the parsed data and append
                d = {}
                d['term'] = td_contents[0]
                d['dept'] = dept
                d['number'] = number
                d['section'] = section
                d['enrollment'] = int(td_contents[2])
                d['median'] = clean_median(td_contents[3])
                d['_id'] = '%s_%s_%s_%s' % (td_contents[0], dept, number, section)
                l.append(d)
                # print d
    
    return l

if __name__ == "__main__":
    print json.dumps({'records':load()})
