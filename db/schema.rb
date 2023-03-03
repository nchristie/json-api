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

ActiveRecord::Schema.define(version: 2016_10_16_080826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id"
    t.string "data"
    t.string "url"
    t.index ["product_id"], name: "index_images_on_product_id"
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id"
    t.integer "order_id"
    t.integer "quantity", default: 1, null: false
    t.integer "price"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "total", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "cancellation_reason"
    t.string "state", default: "confirmed", null: false
    t.integer "promotion_id"
    t.index ["promotion_id"], name: "index_orders_on_promotion_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.boolean "in_stock", default: true
    t.integer "stock_quantity", default: 0, null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "promotions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.integer "product_id"
    t.string "name"
    t.string "code"
    t.integer "discount"
    t.index ["category_id"], name: "index_promotions_on_category_id"
    t.index ["product_id"], name: "index_promotions_on_product_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "user_type"
    t.string "access_token"
  end

  add_foreign_key "images", "products"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "promotions"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "promotions", "categories"
  add_foreign_key "promotions", "products"
end
