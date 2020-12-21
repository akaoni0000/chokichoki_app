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

ActiveRecord::Schema.define(version: 2020_09_25_123008) do

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cancel_reservations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "menu_id"
    t.integer "user_id"
    t.datetime "start_time"
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "notification_status", default: false
    t.string "reservation_token"
  end

  create_table "chat_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "chats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id"
    t.integer "reservation_id"
  end

  create_table "favorites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hairdresser_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "hairdresser_id"
    t.integer "user_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "menu_id"
    t.datetime "start_time"
    t.float "rate", default: 0.0
  end

  create_table "hairdressers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "menus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "money", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "room_token"
  end

  create_table "style_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "hairdresser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hair_images"
  end

  create_table "user_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "customer_id"
    t.string "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
