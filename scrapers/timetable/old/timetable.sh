#!/bin/bash
#Usage ./timetable.sh ListOfURLS
# (c) 2011 Julian Bangert, GPLv2 or later
outfile="timetable.JSON"
URLLIST=$1
for TIMETABLE in `cat $URLLIST`; do
curl $TIMETABLE | ruby timetable2csv.rb | awk '{if (NR!=1) {print}}' | ./timetable.pl  > $outfile
done
