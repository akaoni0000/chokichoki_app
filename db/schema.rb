# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_25_123008) do

  create_table "admins", charset: "utf8", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cancel_reservations", charset: "utf8", force: :cascade do |t|
    t.integer "menu_id"
    t.integer "user_id"
    t.datetime "start_time"
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "notification_status", default: false
    t.string "reservation_token"
  end

  create_table "chat_messages", charset: "utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hairdresser_id"
    t.integer "room_id"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_id"
    t.string "style_images"
    t.boolean "notification", default: false, null: false
  end

  create_table "chats", charset: "utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id"
    t.integer "reservation_id"
  end

  create_table "favorites", charset: "utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hairdresser_comments", charset: "utf8", force: :cascade do |t|
    t.integer "hairdresser_id"
    t.integer "user_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "menu_id"
    t.datetime "start_time"
    t.float "rate", default: 0.0
  end

  create_table "hairdressers", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "introduction"
    t.string "address"
    t.string "shop_name"
    t.string "confirm_image_id"
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
    t.string "activation_digest"
    t.datetime "activation_deadline_at"
    t.string "password_reset_digest"
    t.datetime "password_reset_deadline_at"
    t.boolean "activation_status", default: false
    t.boolean "judge_status", default: false
  end

  create_table "menus", charset: "utf8", force: :cascade do |t|
    t.integer "hairdresser_id"
    t.string "name"
    t.integer "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "explanation"
    t.string "menu_image_id"
    t.string "category"
    t.boolean "status", default: false
  end

  create_table "money", charset: "utf8", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", charset: "utf8", force: :cascade do |t|
    t.integer "menu_id"
    t.integer "user_id"
    t.datetime "start_time"
    t.text "user_request"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: false
    t.boolean "notification_status", default: false
    t.string "reservation_token"
  end

  create_table "rooms", charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "room_token"
  end

  create_table "style_images", charset: "utf8", force: :cascade do |t|
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hair_images"
  end

  create_table "user_cards", charset: "utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "customer_id"
    t.string "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "sex"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "point", default: 500
    t.string "activation_digest"
    t.datetime "activation_deadline_at"
    t.string "password_reset_digest"
    t.datetime "password_reset_deadline_at"
    t.boolean "activation_status", default: false
  end

end
