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

ActiveRecord::Schema.define(:version => 20111014223727) do

# Could not dump table "courses" because of following StandardError
#   Unknown type 'year(4)' for column 'year'

  create_table "departments", :force => true do |t|
    t.string "name",      :limit => 120
    t.string "code",      :limit => 5
    t.string "deptclass", :limit => 7
    t.string "note"
    t.string "url"
    t.string "email"
  end

  create_table "professors", :id => false, :force => true do |t|
    t.integer "id",                         :default => 0,         :null => false
    t.string  "name",        :limit => 120
    t.integer "dept"
    t.string  "note"
    t.string  "officehours"
    t.string  "bio"
    t.string  "cname",       :limit => 100
    t.string  "prefs",                      :default => "FF9900,"
  end

  create_table "profreviews", :force => true do |t|
    t.integer "reviewer"
    t.integer "professor"
    t.integer "course"
    t.integer "reviewid"
    t.integer "plectures"
    t.integer "punderstand"
    t.integer "phelp"
    t.integer "pinclass"
    t.integer "pinspire"
    t.integer "poverall"
    t.integer "interpretas"
    t.integer "pdiversity"
  end

  create_table "teachwhat", :force => true do |t|
    t.integer "profid",   :default => 0, :null => false
    t.integer "courseid", :default => 0, :null => false
  end

  create_table "whatsubject", :force => true do |t|
    t.integer "dept"
    t.integer "coursenumber"
    t.integer "section"
    t.integer "courseid"
  end

end
