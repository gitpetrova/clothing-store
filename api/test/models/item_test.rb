require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "requires a title" do
    item = Item.new(description: "no title")
    assert_not item.valid?
    assert_includes item.errors[:title], "can't be blank"
  end

  test "defaults completed to false" do
    item = Item.create!(title: "Write tests")
    assert_equal false, item.completed
  end
end
