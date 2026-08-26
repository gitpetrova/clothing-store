require "test_helper"

class Api::V1::ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
  end

  test "index returns items" do
    get api_v1_items_url, as: :json
    assert_response :success
    assert_kind_of Array, response.parsed_body
  end

  test "create persists an item" do
    assert_difference("Item.count", 1) do
      post api_v1_items_url, params: { item: { title: "New item", description: "From the test" } }, as: :json
    end

    assert_response :created
    assert_equal "New item", response.parsed_body["title"]
  end

  test "create rejects a blank title" do
    post api_v1_items_url, params: { item: { title: "" } }, as: :json
    assert_response :unprocessable_content
  end

  test "update changes an item" do
    patch api_v1_item_url(@item), params: { item: { completed: true } }, as: :json
    assert_response :success
    assert @item.reload.completed
  end

  test "destroy removes an item" do
    assert_difference("Item.count", -1) do
      delete api_v1_item_url(@item), as: :json
    end

    assert_response :no_content
  end
end
