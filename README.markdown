CourseTown is a [Hacker Club](http://hacktown.cs.dartmouth.edu) project, intended to replace the existing [Course Picker](http://hacktown.cs.dartmouth.edu/nose/) and [Student Assembly Course Guide](http://hacktown.cs.dartmouth.edu/gudru/). 

# Setup

```
$ cd coursetown
$ bundle install
$ gem install mysql2
```
set up the mysql db. something like:
-----------

ALL AT ONCE:

```
echo "create database coursetown_dev; grant all privileges on coursetown_dev.* to coursetown@localhost identified by 'BLP80ZKB8nB8'; create database coursetown_test; grant all privileges on coursetown_test.* to coursetown@localhost  identified by 'BLP80ZKB8nB8'; create database coursetown; grant all privileges on coursetown.* to coursetown@localhost identified by 'BLP80ZKB8nB8';" | mysql -u root -p
```

OR ONE BY ONE:
```
pyrak@parktop:~$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 43
Server version: 5.5.22-0ubuntu1 (Ubuntu)

Copyright (c) 2000, 2011, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database coursetown_dev;
Query OK, 1 row affected (0.14 sec)

mysql> grant all privileges on coursetown_dev.* to coursetown@localhost identified by 'BLP80ZKB8nB8';
Query OK, 0 rows affected (0.00 sec)

mysql> create database coursetown_test;
Query OK, 1 row affected (0.00 sec)

mysql> grant all privileges on coursetown_test.* to coursetown@localhost identified by 'BLP80ZKB8nB8';
Query OK, 0 rows affected (0.00 sec)

mysql> create database coursetown;
Query OK, 1 row affected (0.00 sec)

mysql> grant all privileges on coursetown.* to coursetown@localhost identified by 'BLP80ZKB8nB8';
Query OK, 0 rows affected (0.00 sec)
```

-----------
```
$ rake db:create
$ rake db: migrate
$ rails server
```


To get new JSON, change to ../scrape and run ./scrape_all.sh
To import sample course/offering data (2011F) run:

```
$ rake scrape:orc
$ rake scrape:timetable
$ rake scrape:departments
```

To get the Thinking Sphinx Index going:

$ rake ts:index

If you make any changes to the index, make sure to rebuild it:

$ rake ts:rebuild
Deploy
------

Just push your changes to the repository and our continuous deployment
bot will automatically integrate it into the production app.
