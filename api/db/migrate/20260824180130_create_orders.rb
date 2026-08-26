class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :email, null: false
      t.string :customer_name, null: false
      t.string :status, null: false, default: "pending"
      t.decimal :total, precision: 10, scale: 2, null: false, default: 0
      t.text :shipping_address, null: false

      t.timestamps
    end

    add_index :orders, :email
    add_index :orders, :status
    add_check_constraint :orders, "total >= 0", name: "orders_total_non_negative"
  end
end
