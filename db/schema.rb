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

ActiveRecord::Schema[7.0].define(version: 2023_04_01_000004) do
  create_table "expenses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "payer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payer_id"], name: "index_expenses_on_payer_id"
  end

  create_table "participants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "expense_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_participants_on_expense_id"
    t.index ["user_id", "expense_id"], name: "index_participants_on_user_id_and_expense_id", unique: true
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "payment_statuses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "from_user_id", null: false
    t.bigint "to_user_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "status", default: "pending", null: false
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_payment_statuses_on_expense_id"
    t.index ["from_user_id", "to_user_id", "expense_id"], name: "idx_payment_statuses_unique", unique: true
    t.index ["from_user_id"], name: "index_payment_statuses_on_from_user_id"
    t.index ["to_user_id"], name: "index_payment_statuses_on_to_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "bank_account"
    t.string "bank_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "expenses", "users", column: "payer_id"
  add_foreign_key "participants", "expenses"
  add_foreign_key "participants", "users"
  add_foreign_key "payment_statuses", "expenses"
  add_foreign_key "payment_statuses", "users", column: "from_user_id"
  add_foreign_key "payment_statuses", "users", column: "to_user_id"
end
