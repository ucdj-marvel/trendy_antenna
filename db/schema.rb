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

ActiveRecord::Schema[7.0].define(version: 2022_06_22_084349) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acquisition_results", force: :cascade do |t|
    t.integer "command", default: 0, null: false
    t.jsonb "result", default: {}, null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["command", "date"], name: "index_acquisition_results_on_command_and_date", unique: true
  end

  create_table "command_error_histories", force: :cascade do |t|
    t.integer "command", default: 0, null: false
    t.string "class"
    t.string "message", null: false
    t.text "backtrace"
    t.text "html"
    t.binary "screen_shot"
    t.datetime "error_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genders", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hairstyles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outfit_details", force: :cascade do |t|
    t.bigint "outfit_poster_id", null: false
    t.string "fashion_id", null: false
    t.text "title", null: false
    t.string "img_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outfit_poster_id"], name: "index_outfit_details_on_outfit_poster_id"
  end

  create_table "outfit_posters", force: :cascade do |t|
    t.bigint "gender_id"
    t.bigint "hairstyle_id"
    t.string "user_id", null: false
    t.string "icon_url"
    t.integer "age"
    t.integer "height"
    t.text "intro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gender_id"], name: "index_outfit_posters_on_gender_id"
    t.index ["hairstyle_id"], name: "index_outfit_posters_on_hairstyle_id"
  end

  create_table "outfit_rankings", force: :cascade do |t|
    t.bigint "outfit_detail_id", null: false
    t.bigint "ranking_type_id", null: false
    t.integer "rank", null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outfit_detail_id"], name: "index_outfit_rankings_on_outfit_detail_id"
    t.index ["ranking_type_id"], name: "index_outfit_rankings_on_ranking_type_id"
  end

  create_table "ranking_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "outfit_details", "outfit_posters"
  add_foreign_key "outfit_posters", "genders"
  add_foreign_key "outfit_posters", "hairstyles"
  add_foreign_key "outfit_rankings", "outfit_details"
  add_foreign_key "outfit_rankings", "ranking_types"
end
