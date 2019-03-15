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

ActiveRecord::Schema.define(version: 2019_03_14_003154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "shorten_urls", force: :cascade do |t|
    t.text "original_url", null: false
    t.string "short_url"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "admin_url"
  end

  create_table "url_clicks", force: :cascade do |t|
    t.bigint "shorten_url_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shorten_url_id"], name: "index_url_clicks_on_shorten_url_id"
  end

  add_foreign_key "url_clicks", "shorten_urls"
end
