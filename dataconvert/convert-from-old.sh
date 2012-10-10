#!/bin/sh
rm development.sqlite3 # Maybe not 
PASSWORD=`cat password`
ADDITIONAL_OPTIONS="--no-create-info"
mysqldump -r dump.sql --compatible=ansi --skip-extended-insert --compact  -u root --password=$PASSWORD $ADDITIONAL_OPTIONS courseguide courses departments whatsubject teachwhat professors profreviews
cat dump.sql
#From https://gist.github.com/943776
