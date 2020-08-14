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

ActiveRecord::Schema.define(version: 2020_08_14_023548) do

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cancel_reservations", force: :cascade do |t|
    t.integer "menu_id"
    t.integer "user_id"
    t.datetime "start_time"
    t.integer "hairdresser_id"
    t.integer "notification_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_messages", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hairdresser_id"
    t.integer "room_id"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hairdresser_id"
    t.text "comment"
    t.float "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hairdresser_comments", force: :cascade do |t|
    t.integer "hairdresser_id"
    t.integer "user_id"
    t.text "comment"
    t.float "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "menu_id"
    t.datetime "start_time"
  end

  create_table "hairdressers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "introduction"
    t.string "address"
    t.string "shop_name"
    t.string "confirm_image_id"
    t.integer "status", default: 0
    t.string "hairdresser_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.integer "post_number"
    t.string "sex"
    t.float "reputation_point", default: 0.0
    t.string "reject_status"
    t.float "shop_latitude"
    t.float "shop_longitude"
  end

  create_table "menus", force: :cascade do |t|
    t.integer "hairdresser_id"
    t.string "name"
    t.integer "time"
    t.integer "sex_status", default: 0
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "explanation"
    t.string "menu_image_id"
    t.string "category"
  end

  create_table "money", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "menu_id"
    t.integer "user_id"
    t.datetime "start_time"
    t.text "user_request"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "cancel_status", default: 0
    t.integer "notification_status", default: 0
  end

  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "style_images", force: :cascade do |t|
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hair_images"
  end

  create_table "user_cards", force: :cascade do |t|
    t.integer "user_id"
    t.string "customer_id"
    t.string "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "sex"
    t.string "password_digest"
    t.integer "model_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "point", default: 500
  end

end
