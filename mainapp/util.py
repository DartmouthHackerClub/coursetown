from coursetown.mainapp.models import Course, Offering

import urllib
import urllib2
import cookielib
from html5lib import HTMLParser, treebuilders

def get_ical(section):
    pass

def get_space_remaining(offering):
    dept_abbr = offering.course.dept
    course_num = str(offering.course.num)
    # define
    post_data = {
        'classyear' : '2008', #don't know WHY!?!
        'subj': dept_abbr,
        'crsenum': course_num,
        }
    url = 'http://oracle-www.dartmouth.edu/dart/groucho/timetable.course_quicksearch'

    # get the html
    cj = cookielib.LWPCookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
    urllib2.install_opener(opener)
    headers =  {'User-agent' : 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'}
    request = urllib2.Request(url, urllib.urlencode(post_data), headers)
    handle = urllib2.urlopen(request)
    html = handle.read()
    assert(len(html) > 0)

    # parse the html
    parser = HTMLParser(tree=treebuilders.getTreeBuilder("beautifulsoup"))
    soup = parser.parse(html)
    tbody = soup.find('th', text='Term').parent.parent.parent
    cells = tbody.findAll('tr')[2]('td')
    enrolled = int(cells[-2].contents[0])
    capacity = int(cells[-3].contents[0])

    return capacity-enrolled

def get_books(o):
    pass

def get_reviews(o):
    pass

