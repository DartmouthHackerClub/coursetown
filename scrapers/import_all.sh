#/bin/bash
python medians/medians.py > medians.json
python orc/new_orc.py > orc.json
python timetable/scrape_timetable.py 
cp timetable/timetable.json .
