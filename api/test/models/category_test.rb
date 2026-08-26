require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "requires a name" do
    category = Category.new(slug: "outerwear")
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "generates a slug from the name" do
    category = Category.create!(name: "Outerwear")
    assert_equal "outerwear", category.slug
  end

  test "requires a unique name" do
    category = Category.new(name: categories(:tops).name)
    assert_not category.valid?
    assert_includes category.errors[:name], "has already been taken"
  end

  test "does not destroy a category that still has products" do
    assert_not categories(:tops).destroy
    assert Category.exists?(categories(:tops).id)
  end
end
