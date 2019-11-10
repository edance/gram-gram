# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_10_024219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "photos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ig_id"
    t.text "ig_permalink"
    t.text "ig_caption"
    t.datetime "ig_timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ig_media_url"
    t.index ["ig_id"], name: "index_photos_on_ig_id", unique: true
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "postcards", force: :cascade do |t|
    t.bigint "recipient_id", null: false
    t.bigint "photo_id", null: false
    t.integer "status"
    t.date "delivery_date"
    t.string "lob_id"
    t.text "caption"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["photo_id"], name: "index_postcards_on_photo_id"
    t.index ["recipient_id"], name: "index_postcards_on_recipient_id"
  end

  create_table "recipients", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "lob_address_id"
    t.string "name"
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_city"
    t.string "address_state"
    t.string "address_zip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_recipients_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "instagram_uid"
    t.string "instagram_access_token"
  end

  add_foreign_key "photos", "users"
  add_foreign_key "postcards", "photos"
  add_foreign_key "postcards", "recipients"
  add_foreign_key "recipients", "users"
end
