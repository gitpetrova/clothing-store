class CreateVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku, null: false
      t.string :size, null: false
      t.string :color, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock, null: false, default: 0

      t.timestamps
    end

    add_index :variants, :sku, unique: true
    add_index :variants, [ :product_id, :size, :color ], unique: true

    add_check_constraint :variants, "price >= 0", name: "variants_price_non_negative"
    add_check_constraint :variants, "stock >= 0", name: "variants_stock_non_negative"
  end
end
