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

ActiveRecord::Schema.define(version: 20170504014418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credit_cards", force: :cascade do |t|
    t.integer  "user_id",                                  null: false
    t.text     "cc_number",                                null: false
    t.boolean  "is_default",               default: false, null: false
    t.boolean  "is_enabled",               default: true,  null: false
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
  end

  add_index "credit_cards", ["id"], name: "credit_cards_id_unique", unique: true, using: :btree

  create_table "events", id: false, force: :cascade do |t|
    t.integer  "user_id",               null: false
    t.string   "type",       limit: 20
    t.integer  "project_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followers", id: false, force: :cascade do |t|
    t.integer  "follower_id",                null: false
    t.integer  "following_id",               null: false
    t.datetime "created_at",   precision: 0
    t.datetime "updated_at",   precision: 0
  end

  create_table "migrations", force: :cascade do |t|
    t.string  "migration", limit: 255, null: false
    t.integer "batch",                 null: false
  end

  create_table "password_resets", id: false, force: :cascade do |t|
    t.string   "email",      limit: 255,               null: false
    t.string   "token",      limit: 255,               null: false
    t.datetime "created_at",             precision: 0
  end

  add_index "password_resets", ["email"], name: "password_resets_email_index", using: :btree

  create_table "pledges", id: false, force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.integer  "project_id",               null: false
    t.float    "amount",                   null: false
    t.integer  "cc_card_id",               null: false
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
  end

  create_table "projects", force: :cascade do |t|
    t.text     "title",                                               null: false
    t.text     "description",                                         null: false
    t.integer  "posted_by",                                           null: false
    t.string   "type",                       limit: 10,               null: false
    t.string   "status",                     limit: 10
    t.float    "minimum_fund"
    t.float    "maximum_fund",                                        null: false
    t.datetime "start_date",                            precision: 0
    t.datetime "end_date",                              precision: 0, null: false
    t.datetime "created_at",                            precision: 0
    t.datetime "updated_at",                            precision: 0
    t.text     "tags",                                                             array: true
    t.text     "mini_description"
    t.text     "search_thumbnail_small"
    t.text     "search_thumbnail_large"
    t.text     "video_url"
    t.string   "location",                   limit: 50
    t.string   "project_image_file_name"
    t.string   "project_image_content_type"
    t.integer  "project_image_file_size"
    t.datetime "project_image_updated_at"
  end

  add_index "projects", ["id"], name: "projects_id_unique", unique: true, using: :btree

  create_table "reviews", id: false, force: :cascade do |t|
    t.integer  "user_id",                              null: false
    t.integer  "project_id",                           null: false
    t.string   "type",       limit: 255,               null: false
    t.text     "comment"
    t.integer  "rating"
    t.datetime "created_at",             precision: 0
    t.datetime "updated_at",             precision: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                 limit: 30,               null: false
    t.string   "last_name",                  limit: 30,               null: false
    t.string   "email",                      limit: 40,               null: false
    t.string   "username",                   limit: 20,               null: false
    t.string   "password",                   limit: 20,               null: false
    t.string   "address",                    limit: 50
    t.string   "state",                      limit: 20
    t.string   "country",                    limit: 20
    t.string   "pincode",                    limit: 8
    t.datetime "created_at",                            precision: 0
    t.datetime "updated_at",                            precision: 0
    t.text     "biography"
    t.text     "profile_image_url"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
  end

  add_index "users", ["id"], name: "users_id_unique", unique: true, using: :btree

  add_foreign_key "credit_cards", "users", name: "credit_cards_user_id_foreign", on_delete: :cascade
  add_foreign_key "events", "projects", name: "fk_projects_pledge"
  add_foreign_key "events", "users", column: "profile_id", name: "fk_profile_events"
  add_foreign_key "events", "users", name: "fk_users_events"
  add_foreign_key "followers", "users", column: "follower_id", name: "followers_follower_id_foreign", on_delete: :cascade
  add_foreign_key "followers", "users", column: "following_id", name: "followers_following_id_foreign", on_delete: :cascade
  add_foreign_key "pledges", "credit_cards", column: "cc_card_id", name: "pledges_cc_card_id_foreign", on_delete: :cascade
  add_foreign_key "pledges", "projects", name: "pledges_project_id_foreign", on_delete: :cascade
  add_foreign_key "pledges", "users", name: "pledges_user_id_foreign", on_delete: :cascade
  add_foreign_key "reviews", "projects", name: "reviews_project_id_foreign", on_delete: :cascade
  add_foreign_key "reviews", "users", name: "reviews_user_id_foreign", on_delete: :cascade
end
