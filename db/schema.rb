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

ActiveRecord::Schema.define(version: 20141105042102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

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
    t.string   "url",                    limit: 2048
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "embed_type"
    t.string   "embed_title"
    t.string   "embed_url",              limit: 2048
    t.text     "embed_description"
    t.string   "embed_provider_url",     limit: 2048
    t.string   "embed_author_name"
    t.string   "embed_author_url",       limit: 2048
    t.string   "embed_thumbnail_url",    limit: 2048
    t.integer  "embed_thumbnail_width"
    t.integer  "embed_thumbnail_height"
    t.string   "embed_provider_name"
    t.text     "embed_html"
    t.integer  "embed_height"
    t.integer  "embed_width"
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
