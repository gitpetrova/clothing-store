class CreateProductImages < ActiveRecord::Migration[8.1]
  def change
    create_table :product_images do |t|
      t.references :product, null: false, foreign_key: true
      t.references :variant, null: true, foreign_key: true
      t.string :url, null: false
      t.string :alt_text
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :product_images, [ :product_id, :position ]
    add_check_constraint :product_images, "position >= 0", name: "product_images_position_non_negative"
  end
end
