import json
import urllib2
from html5lib import HTMLParser, treebuilders
import cookielib
import BeautifulSoup


timetable_url = 'http://oracle-www.dartmouth.edu/dart/groucho/timetable.display_courses?subjectradio=allsubjects&depts=no_value&periods=no_value&distribs=no_value&distribs_i=no_value&distribs_wc=no_value&pmode=public&term=&levl=&fys=n&wrt=n&pe=n&review=n&crnl=no_value&classyear=2008&searchtype=General+Education+Requirements&termradio=allterms&terms=no_value&distribradio=alldistribs&hoursradio=allhours&sortorder=dept'
outfile = 'timetable.json'

# utils (should be in a sep file?)

def url_to_html_str(url):
    # setup
    cj = cookielib.LWPCookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
    urllib2.install_opener(opener)
    txheaders =  {'User-agent' : 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'}
    # do it
    req = urllib2.Request(timetable_url, None, txheaders)
    handle = urllib2.urlopen(req)
    html = handle.read() #returns the page
    return html

def html_to_soup(html):
    parser = HTMLParser(tree=treebuilders.getTreeBuilder("beautifulsoup"))
    return parser.parse(html)

def get_innermost_string(soup_obj):
    while type(soup_obj) != BeautifulSoup.NavigableString:
        if not soup_obj.contents:
            return u''
        soup_obj = soup_obj.contents[0]
    return soup_obj.strip()

def table_soup_to_dict(soup, lambda_for_cells=lambda key, value:get_innermost_string(value), header_row_cell_tag='th'):
    rows = soup.findAll('tr')
    keys = rows[0].findAll(header_row_cell_tag)
    keys = map(get_innermost_string, keys)
    rows = rows[1:]
    rows = map(lambda row: row.findAll('td'), rows)
    rows = map(lambda row: map(lambda cell: cell.contents[0], row), rows)
    data = map(lambda row: dict(zip(keys,row)), rows)
    for data_row in data:
        for key, value in data_row.iteritems():
            data_row[key] = lambda_for_cells(key, value)
    return data

# the juicy stuff

def timetable_html_to_dict(html):
    print "making soup..."
    soup = html_to_soup(html)
    print "done"
    print "parsing soup..."
    soup = soup.find('div', {'class': 'data-table'})
    soup = soup.find('tbody')
    data = table_soup_to_dict(soup)
    print "done"
    return data

def get_timetable_html():
    return url_to_html_str(timetable_url)

def main():
    print "opening output file..."
    fp = open(outfile, 'w')
    print "done."
    print "downloading timetable page from registrar website..."
    html = get_timetable_html()
    print "done."
    print "parsing html to create data..."
    data = timetable_html_to_dict(html)
    print "done."
    print "outputting data as json..."
    json.dump(data, fp)
    print "done."

if __name__ == "__main__":
    main()
