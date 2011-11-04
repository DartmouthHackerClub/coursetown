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

ActiveRecord::Schema.define(:version => 20111104213928) do

  create_table "courses", :force => true do |t|
    t.string   "department"
    t.integer  "number"
    t.string   "short_title"
    t.string   "long_title"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distribs", :force => true do |t|
    t.integer  "offering_id"
    t.string   "distrib_name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.boolean  "nroable",        :default => true
  end

  create_table "professors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "offering_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
  end

  create_table "wishlists", :force => true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
