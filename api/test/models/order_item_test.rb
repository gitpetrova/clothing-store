require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  test "requires a positive quantity" do
    item = order_items(:pending_tee)
    item.quantity = 0
    assert_not item.valid?
    assert_includes item.errors[:quantity], "must be greater than 0"
  end

  test "snapshots variant details on create" do
    item = OrderItem.create!(order: orders(:pending_order), variant: variants(:classic_tee_medium_black), quantity: 1)
    assert_equal "Classic Tee", item.product_name
    assert_equal "M", item.size
    assert_equal "Black", item.color
    assert_equal variants(:classic_tee_medium_black).price, item.unit_price
  end

  test "line_total multiplies unit price by quantity" do
    item = order_items(:pending_tee)
    assert_equal item.unit_price * item.quantity, item.line_total
  end
end
