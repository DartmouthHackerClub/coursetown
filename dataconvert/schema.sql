/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "courses" (
  "id" unsigned INTEGER PRIMARY KEY,
  "year" year(4) DEFAULT NULL,
  "term" string DEFAULT NULL,
  "lab" string DEFAULT 'No',
  "median" UNSIGNED INTEGER DEFAULT NULL,
  "listedas" varchar(255) DEFAULT NULL,
  "enrollment" int(11) DEFAULT NULL,
  "allowreview" string DEFAULT 'No',
  "type" string DEFAULT NULL,
  "note" varchar(255) DEFAULT NULL,
  "officehours" varchar(255) DEFAULT NULL,
  "syllabus" text,
  "coursedesc" text,
  "site" string DEFAULT 'NONE',
  "openwhen" datetime DEFAULT NULL,
  "closewhen" datetime DEFAULT NULL,
  "viewlevel" int(10) DEFAULT '0'
);

CREATE TABLE "departments" (
  "id" INTEGER PRIMARY KEY,
  "name" varchar(120) DEFAULT NULL,
  "code" varchar(5) DEFAULT NULL,
  "deptclass" varchar(7) DEFAULT NULL,
  "note" varchar(255) DEFAULT NULL,
  "url" varchar(255) DEFAULT NULL,
  "email" varchar(255) DEFAULT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "whatsubject" (
  "id" INTEGER PRIMARY KEY,
  "dept" unsigned integer DEFAULT NULL,
  "coursenumber" unsigned integer DEFAULT NULL,
  "section" unsigned integer DEFAULT NULL,
  "courseid" unsigned integer DEFAULT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "teachwhat" (
  "id" INTEGER PRIMARY KEY,
  "profid" unsigned integer NOT NULL DEFAULT '0',
  "courseid" unsigned integer NOT NULL DEFAULT '0'
);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "professors" (
  "id" unsigned integer NOT NULL DEFAULT '0',
  "name" varchar(120) DEFAULT NULL,
  "dept" unsigned integer DEFAULT NULL,
  "note" varchar(255) DEFAULT NULL,
  "officehours" varchar(255) DEFAULT NULL,
  "bio" varchar(255) DEFAULT NULL,
  "cname" varchar(100) DEFAULT NULL,
  "prefs" varchar(255) DEFAULT 'FF9900,'

);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "profreviews" (
  "id" INTEGER PRIMARY KEY,
  "reviewer" unsigned integer DEFAULT NULL,
  "professor" unsigned integer DEFAULT NULL,
  "course" unsigned integer DEFAULT NULL,
  "reviewid" unsigned integer DEFAULT NULL,
  "plectures" unsigned integer DEFAULT NULL,
  "punderstand" unsigned integer DEFAULT NULL,
  "phelp" unsigned integer DEFAULT NULL,
  "pinclass" unsigned integer DEFAULT NULL,
  "pinspire" unsigned integer DEFAULT NULL,
  "poverall" unsigned integer DEFAULT NULL,
  "interpretas" unsigned integer DEFAULT NULL,
  "pdiversity" unsigned integer DEFAULT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;
