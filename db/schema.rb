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

ActiveRecord::Schema.define(version: 20141108002526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "entities", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "page_id"
    t.string   "name"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entities", ["name"], name: "index_entities_on_name", using: :btree
  add_index "entities", ["page_id"], name: "index_entities_on_page_id", using: :btree

  create_table "extracted_recommendations", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "page_id"
    t.uuid     "recommended_page_id"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extracted_recommendations", ["page_id"], name: "index_extracted_recommendations_on_page_id", using: :btree
  add_index "extracted_recommendations", ["recommended_page_id"], name: "index_extracted_recommendations_on_recommended_page_id", using: :btree

  create_table "keywords", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "page_id"
    t.string   "name"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["name"], name: "index_keywords_on_name", using: :btree
  add_index "keywords", ["page_id"], name: "index_keywords_on_page_id", using: :btree

  create_table "likes", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.uuid     "page_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["page_id"], name: "index_likes_on_page_id", using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "pages", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "url",                            limit: 2048
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extracted_type"
    t.string   "extracted_title"
    t.string   "extracted_url",                  limit: 2048
    t.text     "extracted_description"
    t.string   "extracted_provider_url",         limit: 2048
    t.string   "extracted_author_name"
    t.string   "extracted_author_url",           limit: 2048
    t.string   "extracted_image_url",            limit: 2048
    t.integer  "extracted_image_width"
    t.integer  "extracted_image_height"
    t.text     "extracted_image_caption"
    t.string   "extracted_image_color"
    t.string   "extracted_provider_name"
    t.text     "extracted_html"
    t.integer  "extracted_height"
    t.integer  "extracted_width"
    t.string   "extracted_provider_display"
    t.boolean  "extracted_safe"
    t.text     "extracted_content"
    t.string   "extracted_favicon_url",          limit: 2048
    t.string   "extracted_favicon_color"
    t.string   "extracted_language"
    t.text     "extracted_lead"
    t.integer  "extracted_cache_age"
    t.integer  "extracted_offset"
    t.integer  "extracted_published",            limit: 8
    t.string   "extracted_media_type"
    t.text     "extracted_media_html"
    t.integer  "extracted_media_height"
    t.integer  "extracted_media_width"
    t.integer  "extracted_media_duration"
    t.float    "extracted_image_entropy"
    t.datetime "extracted_at"
    t.boolean  "should_extract_recommendations",              default: false
  end

  add_index "pages", ["url"], name: "index_pages_on_url", using: :btree

  create_table "saves", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.uuid     "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "saves", ["page_id"], name: "index_saves_on_page_id", using: :btree
  add_index "saves", ["user_id"], name: "index_saves_on_user_id", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "fxa_id"
    t.string   "email"
    t.string   "name"
    t.text     "description"
    t.string   "oauth_token"
    t.string   "oauth_token_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["fxa_id"], name: "index_users_on_fxa_id", unique: true, using: :btree

  create_table "visits", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.uuid     "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visits", ["page_id"], name: "index_visits_on_page_id", using: :btree
  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

end
