#!/bin/bash
#Usage ./timetable.sh Database ListOfURLS
# (c) 2011 Julian Bangert, GPLv2 or later
tmpfile="/tmp/$(basename $0).$$.tmp"
DB=$1
URLLIST=$2                
for TIMETABLE in `cat $URLLIST`
do
cat /dev/null >  $tmpfile
curl $TIMETABLE | ruby timetable2csv.rb | awk '{if (NR!=1) {print}}' | ./timetable.pl  > $tmpfile
curl -X DELETE $1
sleep 0.2
curl -X PUT $1
curl  -H "Content-Type: application/json"  -d @$tmpfile -X POST $1_bulk_docs 
rm $tmpfile
done