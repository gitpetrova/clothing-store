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

ActiveRecord::Schema[8.1].define(version: 2026_08_24_204429) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.string "product_name", null: false
    t.integer "quantity", null: false
    t.string "size", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["variant_id"], name: "index_order_items_on_variant_id"
    t.check_constraint "quantity > 0", name: "order_items_quantity_positive"
    t.check_constraint "unit_price >= 0::numeric", name: "order_items_unit_price_non_negative"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_name", null: false
    t.string "email", null: false
    t.text "shipping_address", null: false
    t.string "status", default: "pending", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["email"], name: "index_orders_on_email"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.check_constraint "total >= 0::numeric", name: "orders_total_non_negative"
  end

  create_table "product_images", force: :cascade do |t|
    t.string "alt_text"
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.bigint "variant_id"
    t.index ["product_id", "position"], name: "index_product_images_on_product_id_and_position"
    t.index ["product_id"], name: "index_product_images_on_product_id"
    t.index ["variant_id"], name: "index_product_images_on_variant_id"
    t.check_constraint "\"position\" >= 0", name: "product_images_position_non_negative"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "role", default: "user", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "variants", force: :cascade do |t|
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.bigint "product_id", null: false
    t.string "size", null: false
    t.string "sku", null: false
    t.integer "stock", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "size", "color"], name: "index_variants_on_product_id_and_size_and_color", unique: true
    t.index ["product_id"], name: "index_variants_on_product_id"
    t.index ["sku"], name: "index_variants_on_sku", unique: true
    t.check_constraint "price >= 0::numeric", name: "variants_price_non_negative"
    t.check_constraint "stock >= 0", name: "variants_stock_non_negative"
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "variants"
  add_foreign_key "orders", "users"
  add_foreign_key "product_images", "products"
  add_foreign_key "product_images", "variants"
  add_foreign_key "products", "categories"
  add_foreign_key "variants", "products"
end
