require "rails_helper"

RSpec.describe "Admin authorization", type: :request do
  it "forbids regular users from admin endpoints" do
    post "/api/v1/admin/categories", headers: auth_headers(users(:jane)), params: {
      category: { name: "Sale" }
    }, as: :json

    expect(response).to have_http_status(:forbidden)
    expect(Category.find_by(name: "Sale")).to be_nil
  end

  it "allows an admin to create catalog records" do
    post "/api/v1/admin/categories", headers: auth_headers(users(:admin)), params: {
      category: { name: "Outerwear", description: "Jackets and coats" }
    }, as: :json

    expect(response).to have_http_status(:created)
    expect(response.parsed_body["slug"]).to eq("outerwear")
  end

  it "allows an admin to create a product and variant" do
    post "/api/v1/admin/products", headers: auth_headers(users(:admin)), params: {
      product: { name: "Wool Coat", category_id: categories(:tops).id, description: "Winter coat" }
    }, as: :json

    expect(response).to have_http_status(:created)
    product_id = response.parsed_body["id"]

    post "/api/v1/admin/products/#{product_id}/variants", headers: auth_headers(users(:admin)), params: {
      variant: { sku: "COAT-M-NAV", size: "M", color: "Navy", price: 220, stock: 6 }
    }, as: :json

    expect(response).to have_http_status(:created)
    expect(response.parsed_body["sku"]).to eq("COAT-M-NAV")
  end

  it "allows an admin to list every order and update status" do
    get "/api/v1/admin/orders", headers: auth_headers(users(:admin)), as: :json

    expect(response).to have_http_status(:ok)
    ids = response.parsed_body.map { |order| order["id"] }
    expect(ids).to include(orders(:pending_order).id, orders(:paid_order).id)

    patch "/api/v1/admin/orders/#{orders(:pending_order).id}", headers: auth_headers(users(:admin)), params: {
      order: { status: "shipped" }
    }, as: :json

    expect(response).to have_http_status(:ok)
    expect(orders(:pending_order).reload).to be_shipped
  end

  it "allows an admin to list users" do
    get "/api/v1/admin/users", headers: auth_headers(users(:admin)), as: :json

    expect(response).to have_http_status(:ok)
    emails = response.parsed_body.map { |user| user["email"] }
    expect(emails).to include("admin@example.com", "jane@example.com")
  end
end
