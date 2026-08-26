class AddUserToOrders < ActiveRecord::Migration[8.1]
  def up
    add_reference :orders, :user, foreign_key: true

    if Order.where(user_id: nil).exists?
      user = User.find_or_create_by!(email: "migration@example.com") do |record|
        record.name = "Migration User"
        record.password = SecureRandom.hex(16)
        record.role = :user
      end
      Order.where(user_id: nil).update_all(user_id: user.id)
    end

    change_column_null :orders, :user_id, false
  end

  def down
    remove_reference :orders, :user, foreign_key: true
  end
end
