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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151223025229) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inspections", force: :cascade do |t|
    t.integer  "loe_case_id"
    t.string   "ad_st_apt"
    t.string   "ad_st_name"
    t.string   "ad_st_num"
    t.string   "ad_st_type"
    t.integer  "case_number"
    t.integer  "case_sakey"
    t.string   "compliant"
    t.datetime "entry_date"
    t.datetime "inspection_date"
    t.text     "inspection_notes"
    t.integer  "inspection_sakey"
    t.string   "inspection_type"
    t.string   "inspection_type_desc"
    t.string   "inspector"
    t.datetime "last_update"
    t.string   "open_and_vacant"
    t.string   "unfounded"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "loe_cases", force: :cascade do |t|
    t.string   "ad_lot"
    t.integer  "ad_sakey"
    t.string   "ad_st_apt"
    t.string   "ad_st_name"
    t.string   "ad_st_num"
    t.string   "ad_st_type"
    t.date     "annex_date"
    t.string   "assigned_inspector_code"
    t.string   "assignment"
    t.text     "case_notes"
    t.integer  "case_number"
    t.string   "case_status"
    t.string   "case_type"
    t.string   "census_tract"
    t.datetime "close_date"
    t.string   "close_reason"
    t.datetime "due_date"
    t.datetime "entry_date"
    t.datetime "last_update"
    t.string   "origin"
    t.string   "owner_mailaddr"
    t.string   "owner_mailaddr2"
    t.string   "owner_mailcity"
    t.string   "owner_mailstate"
    t.string   "owner_mailzip"
    t.string   "owner_name"
    t.string   "owner_name2"
    t.string   "rental_status"
    t.string   "use_code"
    t.string   "zoning"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
