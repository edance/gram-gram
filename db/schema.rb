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

ActiveRecord::Schema.define(version: 2020_07_20_221239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "caption"
    t.integer "status", default: 0, null: false
    t.string "stripe_charge_id"
    t.uuid "photo_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["photo_id"], name: "index_orders_on_photo_id"
  end

  create_table "orders_recipients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id", null: false
    t.uuid "recipient_id", null: false
    t.index ["order_id"], name: "index_orders_recipients_on_order_id"
    t.index ["recipient_id"], name: "index_orders_recipients_on_recipient_id"
  end

  create_table "photos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "ig_id"
    t.text "ig_permalink"
    t.text "ig_caption"
    t.datetime "ig_timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ig_media_url"
    t.uuid "user_id"
    t.string "url"
    t.index ["ig_id", "user_id"], name: "index_photos_on_ig_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "postcard_receipts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "lob_id"
    t.integer "status", default: 0, null: false
    t.string "address_name"
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_city"
    t.string "address_state"
    t.string "address_zip"
    t.uuid "recipient_id", null: false
    t.uuid "order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "expected_delivery_date"
    t.index ["order_id"], name: "index_postcard_receipts_on_order_id"
    t.index ["recipient_id"], name: "index_postcard_receipts_on_recipient_id"
  end

  create_table "postcards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.date "delivery_date"
    t.string "lob_id"
    t.text "caption"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_charge_id"
    t.uuid "photo_id"
    t.uuid "recipient_id"
    t.string "address_name"
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_city"
    t.string "address_state"
    t.string "address_zip"
    t.index ["photo_id"], name: "index_postcards_on_photo_id"
    t.index ["recipient_id"], name: "index_postcards_on_recipient_id"
  end

  create_table "recipients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "lob_address_id"
    t.string "name"
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_city"
    t.string "address_state"
    t.string "address_zip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "user_id"
    t.index ["user_id"], name: "index_recipients_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "instagram_uid"
    t.string "instagram_access_token"
    t.string "ig_username"
    t.string "payment_customer_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "ig_avatar"
    t.boolean "private_profile"
    t.datetime "sync_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "orders", "photos"
  add_foreign_key "orders_recipients", "orders"
  add_foreign_key "orders_recipients", "recipients"
  add_foreign_key "postcard_receipts", "orders"
  add_foreign_key "postcard_receipts", "recipients"
end
