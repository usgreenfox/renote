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

ActiveRecord::Schema.define(version: 2022_01_05_094648) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_bookmarks_on_note_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "note_id"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_comments_on_note_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "entities", force: :cascade do |t|
    t.string "name"
    t.float "salience"
    t.string "category"
    t.integer "user_id"
    t.integer "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_entities_on_note_id"
    t.index ["user_id"], name: "index_entities_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.integer "user_id"
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "in_private", default: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "reminds", force: :cascade do |t|
    t.integer "user_id"
    t.integer "note_id"
    t.integer "first_notice", default: 1, null: false
    t.integer "second_notice", default: 7, null: false
    t.integer "third_notice", default: 30, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_reminds_on_note_id"
    t.index ["user_id"], name: "index_reminds_on_user_id"
  end

  create_table "tag_maps", force: :cascade do |t|
    t.integer "note_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_tag_maps_on_note_id"
    t.index ["tag_id"], name: "index_tag_maps_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
