require "rails_helper"

RSpec.describe "Catalog", type: :request do
  it "lists categories without authentication" do
    get "/api/v1/categories", as: :json

    expect(response).to have_http_status(:ok)
    names = response.parsed_body.map { |category| category["name"] }
    expect(names).to include("Tops", "Bottoms")
  end
end
