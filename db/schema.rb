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

ActiveRecord::Schema.define(version: 20150301093405) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "categoryType"
    t.string   "belongsTo"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_user_relations", force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "userRole"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "visibility"
    t.string   "eventType"
    t.string   "location"
    t.string   "postalCode"
    t.string   "country"
    t.datetime "startDate"
    t.datetime "endDate"
    t.integer  "maxCapacity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_user_relations", force: true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "userRole"
    t.string   "userOccupationTitle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "website"
    t.string   "generalEmail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.string   "ticketType"
    t.string   "price"
    t.string   "barcode"
    t.boolean  "isClaimed",  default: false
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "quantity"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "birthDate"
    t.string   "gender"
    t.string   "userEmail"
    t.string   "userToken"
    t.boolean  "isSuper",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end