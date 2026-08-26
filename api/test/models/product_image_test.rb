require "test_helper"

class ProductImageTest < ActiveSupport::TestCase
  test "requires a url" do
    image = ProductImage.new(product: products(:classic_tee))
    assert_not image.valid?
    assert_includes image.errors[:url], "can't be blank"
  end

  test "can belong to a product without a variant" do
    image = product_images(:classic_tee_front)
    assert_nil image.variant
    assert image.valid?
  end

  test "rejects a variant from another product" do
    image = ProductImage.new(
      product: products(:classic_tee),
      variant: variants(:slim_chinos_32_khaki),
      url: "https://example.com/mismatch.jpg"
    )
    assert_not image.valid?
    assert_includes image.errors[:variant], "must belong to the same product"
  end
end
