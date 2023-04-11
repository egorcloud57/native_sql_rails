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

ActiveRecord::Schema[7.0].define(version: 2023_03_25_211452) do
  create_table "account", primary_key: "account_id", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "product_cd", limit: 10, null: false
    t.integer "cust_id", null: false, unsigned: true
    t.date "open_date", null: false
    t.date "close_date"
    t.date "last_activity_date"
    t.column "status", "enum('ACTIVE','CLOSED','FROZEN')"
    t.integer "open_branch_id", limit: 2, unsigned: true
    t.integer "open_emp_id", limit: 2, unsigned: true
    t.float "avail_balance"
    t.float "pending_balance"
    t.index ["cust_id"], name: "fk_a_cust_id"
    t.index ["open_branch_id"], name: "fk_a_branch_id"
    t.index ["open_emp_id"], name: "fk_a_emp_id"
    t.index ["product_cd"], name: "fk_product_cd"
  end

  create_table "branch", primary_key: "branch_id", id: { type: :integer, limit: 2, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.string "address", limit: 30
    t.string "city", limit: 20
    t.string "state", limit: 2
    t.string "zip", limit: 12
  end

  create_table "business", primary_key: "cust_id", id: { type: :integer, unsigned: true, default: nil }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 40, null: false
    t.string "state_id", limit: 10, null: false
    t.date "incorp_date"
  end

  create_table "customer", primary_key: "cust_id", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "fed_id", limit: 12, null: false
    t.column "cust_type_cd", "enum('I','B')", null: false
    t.string "address", limit: 30
    t.string "city", limit: 20
    t.string "state", limit: 20
    t.string "postal_code", limit: 10
  end

  create_table "department", primary_key: "dept_id", id: { type: :integer, limit: 2, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 20, null: false
  end

  create_table "employee", primary_key: "emp_id", id: { type: :integer, limit: 2, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "fname", limit: 20, null: false
    t.string "lname", limit: 20, null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.integer "superior_emp_id", limit: 2, unsigned: true
    t.integer "dept_id", limit: 2, unsigned: true
    t.string "title", limit: 20
    t.integer "assigned_branch_id", limit: 2, unsigned: true
    t.index ["assigned_branch_id"], name: "fk_e_branch_id"
    t.index ["dept_id"], name: "fk_dept_id"
    t.index ["superior_emp_id"], name: "fk_e_emp_id"
  end

  create_table "favorite_food", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.bigint "person_id", null: false, unsigned: true
    t.string "food", limit: 20
    t.index ["person_id"], name: "fk_person_id"
  end

  create_table "individual", primary_key: "cust_id", id: { type: :integer, unsigned: true, default: nil }, charset: "utf8mb4", force: :cascade do |t|
    t.string "fname", limit: 30, null: false
    t.string "lname", limit: 30, null: false
    t.date "birth_date"
  end

  create_table "officer", primary_key: "officer_id", id: { type: :integer, limit: 2, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "cust_id", null: false, unsigned: true
    t.string "fname", limit: 30, null: false
    t.string "lname", limit: 30, null: false
    t.string "title", limit: 20
    t.date "start_date", null: false
    t.date "end_date"
    t.index ["cust_id"], name: "fk_o_cust_id"
  end

  create_table "person", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "fname", limit: 20
    t.string "lname", limit: 20
    t.string "address", limit: 30
    t.string "city", limit: 20
    t.string "state", limit: 20
    t.string "country", limit: 20
    t.string "postal_code", limit: 20
    t.column "gender", "enum('M','F')", null: false
    t.date "birth_date"
  end

  create_table "product", primary_key: "product_cd", id: { type: :string, limit: 10 }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "product_type_cd", limit: 10, null: false
    t.date "date_offered"
    t.date "date_retired"
    t.index ["product_type_cd"], name: "fk_product_type_cd"
  end

  create_table "product_type", primary_key: "product_type_cd", id: { type: :string, limit: 10 }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 50, null: false
  end

  create_table "transaction", primary_key: "txn_id", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.datetime "txn_date", precision: nil, null: false
    t.integer "account_id", null: false, unsigned: true
    t.column "txn_type_cd", "enum('DBT','CDT')"
    t.float "amount", limit: 53, null: false
    t.integer "teller_emp_id", limit: 2, unsigned: true
    t.integer "execution_branch_id", limit: 2, unsigned: true
    t.datetime "funds_avail_date", precision: nil
    t.index ["account_id"], name: "fk_t_account_id"
    t.index ["execution_branch_id"], name: "fk_exec_branch_id"
    t.index ["teller_emp_id"], name: "fk_teller_emp_id"
  end

  add_foreign_key "account", "branch", column: "open_branch_id", primary_key: "branch_id", name: "fk_a_branch_id"
  add_foreign_key "account", "customer", column: "cust_id", primary_key: "cust_id", name: "fk_a_cust_id"
  add_foreign_key "account", "employee", column: "open_emp_id", primary_key: "emp_id", name: "fk_a_emp_id"
  add_foreign_key "account", "product", column: "product_cd", primary_key: "product_cd", name: "fk_product_cd"
  add_foreign_key "business", "customer", column: "cust_id", primary_key: "cust_id", name: "fk_b_cust_id"
  add_foreign_key "employee", "branch", column: "assigned_branch_id", primary_key: "branch_id", name: "fk_e_branch_id"
  add_foreign_key "employee", "department", column: "dept_id", primary_key: "dept_id", name: "fk_dept_id"
  add_foreign_key "employee", "employee", column: "superior_emp_id", primary_key: "emp_id", name: "fk_e_emp_id"
  add_foreign_key "favorite_food", "person", name: "fk_person_id"
  add_foreign_key "individual", "customer", column: "cust_id", primary_key: "cust_id", name: "fk_i_cust_id"
  add_foreign_key "officer", "business", column: "cust_id", primary_key: "cust_id", name: "fk_o_cust_id"
  add_foreign_key "product", "product_type", column: "product_type_cd", primary_key: "product_type_cd", name: "fk_product_type_cd"
  add_foreign_key "transaction", "account", primary_key: "account_id", name: "fk_t_account_id"
  add_foreign_key "transaction", "branch", column: "execution_branch_id", primary_key: "branch_id", name: "fk_exec_branch_id"
  add_foreign_key "transaction", "employee", column: "teller_emp_id", primary_key: "emp_id", name: "fk_teller_emp_id"
end
