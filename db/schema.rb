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

ActiveRecord::Schema[7.0].define(version: 2024_02_29_095107) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nationalities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_nationalities_on_name", unique: true
  end

  create_table "surname_nationalities", force: :cascade do |t|
    t.bigint "surname_id", null: false
    t.bigint "nationality_id", null: false
    t.string "surname_name"
    t.string "nationality_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nationality_id"], name: "index_surname_nationalities_on_nationality_id"
    t.index ["surname_id"], name: "index_surname_nationalities_on_surname_id"
  end

  create_table "surnames", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_surnames_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "surname_nationalities", "nationalities"
  add_foreign_key "surname_nationalities", "surnames"
end
