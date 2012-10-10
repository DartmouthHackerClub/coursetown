#!/usr/bin/env python
#
# ORC parser
#

import sys
import re
import urllib
import json
from BeautifulSoup import BeautifulSoup
import traceback

# Find the listed median pages, download and parse the data, and return a
# list of dicts, one for each orc listing.
def load():
    data = urllib.urlopen('http://www.dartmouth.edu/~reg/courses/desc/index.html').read()

    # Find links to individual orc
    urls = re.findall(r'http://www.dartmouth.edu/~reg/courses/desc/(.*?)\.html', data)

    if not urls:
        print "Couldn't find course desc links"
        sys.exit(1)

    l = []
    for url in urls:
        if url.endswith('-req'):
            continue

        dept = url.upper()
        data = urllib.urlopen('http://www.dartmouth.edu/~reg/courses/desc/%s.html' % (url)).read()
        soup = BeautifulSoup(data)
        for p in soup.findAll('p', attrs={'class':'coursetitle'}):
            if not p.string:
                continue

            nums = re.findall(r'\d+', p.string)
            if not nums or len(nums) < 1:
                continue

            id = nums[0]

            p = p.findNext('p', attrs={'class':'courseoffered'})
            if not p or not p.string:
                continue
            offered = p.string
            
            p = p.findNext('p', attrs={'class':'coursedescptnpar'})
            if not p or not p.string:
                continue
            description = p.string

            l.append(dict(id=id, offered=offered, description=description, dept=dept))
    
    return l

if __name__ == "__main__":
    print json.dumps({'records':load()})
