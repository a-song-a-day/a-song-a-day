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

ActiveRecord::Schema.define(version: 20160723110021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_access_tokens_on_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_access_tokens_on_user_id", using: :btree
  end

  create_table "curators", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",                       null: false
    t.text     "description",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "random",      default: false, null: false
    t.integer  "genre_id"
    t.index ["genre_id"], name: "index_curators_on_genre_id", using: :btree
    t.index ["random"], name: "index_curators_on_random", unique: true, where: "(random = true)", using: :btree
    t.index ["user_id"], name: "index_curators_on_user_id", using: :btree
  end

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "primary",    default: false
  end

  create_table "songs", force: :cascade do |t|
    t.integer  "curator_id"
    t.string   "url",         null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.string   "image_url"
    t.datetime "sent_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["curator_id"], name: "index_songs_on_curator_id", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "curator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curator_id"], name: "index_subscriptions_on_curator_id", using: :btree
    t.index ["user_id"], name: "index_subscriptions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                              null: false
    t.string   "email",                             null: false
    t.text     "extra_information"
    t.boolean  "curator",           default: false, null: false
    t.boolean  "admin",             default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "confirmed_email",   default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "access_tokens", "users", on_delete: :cascade
  add_foreign_key "curators", "genres"
  add_foreign_key "curators", "users", on_delete: :cascade
  add_foreign_key "songs", "curators"
  add_foreign_key "subscriptions", "curators", on_delete: :cascade
  add_foreign_key "subscriptions", "users", on_delete: :cascade
end
