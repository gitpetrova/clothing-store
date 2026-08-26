require "test_helper"

class VariantTest < ActiveSupport::TestCase
  test "requires sku, size, color, and price" do
    variant = Variant.new(product: products(:classic_tee))
    assert_not variant.valid?
    assert_includes variant.errors[:sku], "can't be blank"
    assert_includes variant.errors[:size], "can't be blank"
    assert_includes variant.errors[:color], "can't be blank"
    assert_includes variant.errors[:price], "can't be blank"
  end

  test "defaults stock to 0" do
    assert_equal 0, Variant.new.stock
  end

  test "rejects negative price and stock" do
    variant = variants(:classic_tee_small_black)
    variant.price = -1
    variant.stock = -1
    assert_not variant.valid?
    assert_includes variant.errors[:price], "must be greater than or equal to 0"
    assert_includes variant.errors[:stock], "must be greater than or equal to 0"
  end

  test "requires a unique size and color per product" do
    existing = variants(:classic_tee_small_black)
    duplicate = Variant.new(product: existing.product, sku: "TEE-S-BLK-2", size: existing.size, color: existing.color, price: 29, stock: 1)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:size], "and color combination already exists for this product"
  end

  test "in_stock? reflects stock count" do
    assert variants(:classic_tee_small_black).in_stock?
    variants(:classic_tee_small_black).update!(stock: 0)
    assert_not variants(:classic_tee_small_black).in_stock?
  end
end
