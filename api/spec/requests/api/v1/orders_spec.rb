require "rails_helper"

RSpec.describe "Orders", type: :request do
  it "requires authentication" do
    get "/api/v1/orders", as: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it "lists only the current user's orders" do
    get "/api/v1/orders", headers: auth_headers(users(:jane)), as: :json

    expect(response).to have_http_status(:ok)
    ids = response.parsed_body.map { |order| order["id"] }
    expect(ids).to include(orders(:pending_order).id)
    expect(ids).not_to include(orders(:paid_order).id)
  end

  it "does not show another user's order" do
    get "/api/v1/orders/#{orders(:paid_order).id}", headers: auth_headers(users(:jane)), as: :json

    expect(response).to have_http_status(:not_found)
  end

  it "creates an order, snapshots the variant, and decrements stock" do
    variant = variants(:classic_tee_medium_black)
    stock_before = variant.stock

    post "/api/v1/orders", headers: auth_headers(users(:jane)), params: {
      order: {
        shipping_address: "99 King St",
        items: [ { variant_id: variant.id, quantity: 2 } ]
      }
    }, as: :json

    expect(response).to have_http_status(:created)
    expect(response.parsed_body["status"]).to eq("pending")
    expect(response.parsed_body["email"]).to eq("jane@example.com")
    expect(response.parsed_body["order_items"].first["product_name"]).to eq("Classic Tee")
    expect(response.parsed_body["total"].to_d).to eq(58)
    expect(variant.reload.stock).to eq(stock_before - 2)
  end

  it "rejects an order when stock is too low" do
    variant = variants(:slim_chinos_32_khaki)

    post "/api/v1/orders", headers: auth_headers(users(:jane)), params: {
      order: {
        shipping_address: "99 King St",
        items: [ { variant_id: variant.id, quantity: variant.stock + 1 } ]
      }
    }, as: :json

    expect(response).to have_http_status(:unprocessable_content)
  end
end
