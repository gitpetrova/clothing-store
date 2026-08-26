require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "requires customer details" do
    order = Order.new
    assert_not order.valid?
    assert_includes order.errors[:email], "can't be blank"
    assert_includes order.errors[:customer_name], "can't be blank"
    assert_includes order.errors[:shipping_address], "can't be blank"
  end

  test "rejects an invalid email" do
    order = orders(:pending_order)
    order.email = "not-an-email"
    assert_not order.valid?
    assert_includes order.errors[:email], "is invalid"
  end

  test "defaults status to pending" do
    order = Order.create!(
      user: users(:jane),
      shipping_address: "1 Market St"
    )
    assert_equal "pending", order.status
    assert_equal users(:jane).email, order.email
  end

  test "rejects an unknown status" do
    order = orders(:pending_order)
    order.status = "lost"
    assert_not order.valid?
    assert_includes order.errors[:status], "is not included in the list"
  end

  test "has many order items" do
    assert_includes orders(:pending_order).order_items, order_items(:pending_tee)
  end
end
