# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120510002752) do

  create_table "courses", :force => true do |t|
    t.string   "department"
    t.integer  "number"
    t.string   "short_title"
    t.string   "long_title"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.string   "abbr"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distribs", :force => true do |t|
    t.integer "offering_id"
    t.string  "distrib_name"
    t.string  "distrib_abbr"
  end

  create_table "offering_courses", :force => true do |t|
    t.integer  "course_id"
    t.integer  "offering_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offering_professors", :force => true do |t|
    t.integer  "professor_id"
    t.integer  "offering_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offerings", :force => true do |t|
    t.integer  "year"
    t.string   "term"
    t.string   "time"
    t.float    "median_grade"
    t.string   "specific_title"
    t.string   "wc"
    t.text     "specific_desc"
    t.boolean  "unconfirmed"
    t.string   "crn"
    t.integer  "section"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "nroable",                    :default => true
    t.string   "building"
    t.string   "room"
    t.integer  "enrollment_cap"
    t.integer  "enrolled"
    t.boolean  "median_from_transcript"
    t.boolean  "enrollment_from_transcript"
    t.integer  "old_id"
  end

  create_table "old_reviews", :force => true do |t|
    t.integer  "coverall",          :limit => 2
    t.integer  "cpace",             :limit => 2
    t.integer  "cwork",             :limit => 2
    t.integer  "cinterest",         :limit => 2
    t.integer  "hlearn",            :limit => 2
    t.integer  "hhard",             :limit => 2
    t.integer  "hinterest",         :limit => 2
    t.integer  "efair",             :limit => 2
    t.integer  "ehard",             :limit => 2
    t.integer  "loverall",          :limit => 2
    t.integer  "lhard",             :limit => 2
    t.integer  "ledvalue",          :limit => 2
    t.integer  "ctas",              :limit => 2
    t.string   "rmajor",            :limit => 2
    t.string   "rneed",             :limit => 2
    t.integer  "reffort",           :limit => 2
    t.string   "roffice",           :limit => 2
    t.integer  "rattend",           :limit => 2
    t.string   "title"
    t.text     "creview",           :limit => 16777215
    t.text     "lreview",           :limit => 16777215
    t.text     "fsreview",          :limit => 16777215
    t.string   "approved",          :limit => 0
    t.string   "modified",          :limit => 0
    t.text     "note"
    t.integer  "reviewer"
    t.integer  "rterm",             :limit => 2
    t.datetime "date"
    t.datetime "modifiedat",                            :null => false
    t.string   "rnotify",           :limit => 0
    t.integer  "ltas",              :limit => 2
    t.integer  "interpretas",       :limit => 2
    t.string   "rhappygrade",       :limit => 0
    t.integer  "cmatchorc",         :limit => 2
    t.string   "ip",                :limit => 18
    t.string   "hostname",          :limit => 200
    t.integer  "ryear"
    t.datetime "lastviewedforedit",                     :null => false
    t.integer  "cdiversity",        :limit => 2
    t.integer  "old_id"
    t.integer  "old_offering_id"
  end

  create_table "professors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "offering_id"
    t.integer  "grade"
    t.integer  "prof_rating"
    t.integer  "course_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "course_comment"
    t.text     "prof_comment"
    t.text     "workload_comment"
    t.integer  "workload_rating"
    t.boolean  "for_interest"
    t.boolean  "for_prof"
    t.boolean  "for_major"
    t.boolean  "for_distrib"
    t.boolean  "for_easy_a"
    t.boolean  "for_prereq"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "offering_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.integer  "review_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.string   "netid"
  end

  create_table "wishlists", :force => true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
