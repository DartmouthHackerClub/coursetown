#!/bin/sh
#
# to make index searchable at http://hacktown.cs.dartmouth.edu/search/medians/medians/_search
#

curl -XPUT 'http://hacktown.cs.dartmouth.edu:9200/_river/medians/_meta' -d '{
    "type" : "couchdb",
    "couchdb" : {
        "host" : "hacktown.cs.dartmouth.edu",
        "port" : 5984,
        "db" : "medians",
        "filter" : null
    }
}'
