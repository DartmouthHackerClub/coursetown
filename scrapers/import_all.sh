#/bin/bash
medians/medians.py > medians.json
orc/orc.py > orc.json
python timetable/scrape_timetable.py 
cp timetable/timetable.json .
