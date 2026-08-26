require "rails_helper"

RSpec.describe "Products", type: :request do
  it "requires authentication to list products" do
    get "/api/v1/products", as: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it "lists products with serialized variants and images" do
    get "/api/v1/products", headers: auth_headers(users(:jane)), as: :json

    expect(response).to have_http_status(:ok)
    tee = response.parsed_body.find { |product| product["slug"] == "classic-tee" }

    expect(tee["category"]["slug"]).to eq("tops")
    expect(tee["price_from"]).to eq("29.00")
    expect(tee["in_stock"]).to be(true)
    expect(tee["colors"]).to include("Black")
    expect(tee["variants"].length).to eq(2)
    expect(tee["variants"].first).to include("sku", "size", "color", "price", "stock", "in_stock")
    expect(tee["images"].length).to eq(2)
    expect(tee["primary_image"]).to include("url")
  end

  it "filters products by category" do
    get "/api/v1/products",
      params: { category_id: categories(:tops).id },
      headers: auth_headers(users(:jane)).merge("Accept" => "application/json")

    expect(response).to have_http_status(:ok)
    slugs = response.parsed_body.map { |product| product["slug"] }
    expect(slugs).to include("classic-tee")
    expect(slugs).not_to include("slim-chinos")
  end

  it "shows one product" do
    product = products(:classic_tee)
    get "/api/v1/products/#{product.id}", headers: auth_headers(users(:jane)), as: :json

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["name"]).to eq("Classic Tee")
    expect(response.parsed_body["variants"].map { |variant| variant["sku"] }).to include("TEE-S-BLK")
  end

  it "lists variants for a product" do
    get "/api/v1/products/#{products(:classic_tee).id}/variants",
      headers: auth_headers(users(:jane)),
      as: :json

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.map { |variant| variant["sku"] }).to include("TEE-S-BLK", "TEE-M-BLK")
  end

  it "shows a single variant" do
    variant = variants(:classic_tee_small_black)
    get "/api/v1/variants/#{variant.id}", headers: auth_headers(users(:jane)), as: :json

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to include(
      "sku" => "TEE-S-BLK",
      "size" => "S",
      "color" => "Black",
      "price" => "29.00",
      "in_stock" => true
    )
  end
end
