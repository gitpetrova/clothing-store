require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "requires a name and category" do
    product = Product.new
    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
    assert_includes product.errors[:category], "must exist"
  end

  test "generates a slug from the name" do
    product = Product.create!(category: categories(:tops), name: "Linen Shirt")
    assert_equal "linen-shirt", product.slug
  end

  test "requires a unique slug" do
    product = Product.new(category: categories(:tops), name: "Other Tee", slug: products(:classic_tee).slug)
    assert_not product.valid?
    assert_includes product.errors[:slug], "has already been taken"
  end

  test "has many variants" do
    assert_includes products(:classic_tee).variants, variants(:classic_tee_small_black)
  end
end
