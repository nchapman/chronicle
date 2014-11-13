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

ActiveRecord::Schema.define(version: 20141113055513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "extracted_entities", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "page_id",    null: false
    t.string   "name"
    t.integer  "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extracted_keywords", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "page_id",    null: false
    t.string   "name"
    t.float    "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "url",                                     null: false
    t.string   "extracted_type"
    t.string   "extracted_title"
    t.string   "extracted_url",              limit: 2048
    t.text     "extracted_description"
    t.string   "extracted_provider_url",     limit: 2048
    t.string   "extracted_author_name"
    t.string   "extracted_author_url",       limit: 2048
    t.string   "extracted_image_url",        limit: 2048
    t.integer  "extracted_image_width"
    t.integer  "extracted_image_height"
    t.float    "extracted_image_entropy"
    t.text     "extracted_image_caption"
    t.string   "extracted_image_color"
    t.string   "extracted_provider_name"
    t.text     "extracted_html"
    t.integer  "extracted_height"
    t.integer  "extracted_width"
    t.string   "extracted_provider_display"
    t.boolean  "extracted_safe"
    t.text     "extracted_content"
    t.string   "extracted_favicon_url",      limit: 2048
    t.string   "extracted_favicon_color"
    t.string   "extracted_language"
    t.text     "extracted_lead"
    t.integer  "extracted_cache_age"
    t.integer  "extracted_offset"
    t.integer  "extracted_published",        limit: 8
    t.string   "extracted_media_type"
    t.text     "extracted_media_html"
    t.integer  "extracted_media_height"
    t.integer  "extracted_media_width"
    t.integer  "extracted_media_duration"
    t.datetime "extracted_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "parsed_title"
    t.text     "parsed_html"
    t.text     "parsed_content"
    t.integer  "parsed_status_code"
    t.string   "parsed_content_type"
    t.datetime "parsed_at"
  end

  add_index "pages", ["url"], name: "index_pages_on_url", unique: true, using: :btree

  create_table "user_pages", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id",     null: false
    t.uuid     "page_id",     null: false
    t.string   "title"
    t.text     "description"
    t.boolean  "saved"
    t.boolean  "liked"
    t.boolean  "read"
    t.datetime "saved_at"
    t.datetime "liked_at"
    t.datetime "read_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "fxa_uid",          null: false
    t.string   "email",            null: false
    t.string   "name"
    t.text     "description"
    t.string   "oauth_token",      null: false
    t.string   "oauth_token_type", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "users", ["fxa_uid"], name: "index_users_on_fxa_uid", unique: true, using: :btree

  create_table "visits", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id",      null: false
    t.uuid     "user_page_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "extracted_entities", "pages"
  add_foreign_key "extracted_keywords", "pages"
  add_foreign_key "user_pages", "pages"
  add_foreign_key "user_pages", "users"
  add_foreign_key "visits", "user_pages"
  add_foreign_key "visits", "users"
end
