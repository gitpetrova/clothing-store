require "rails_helper"

RSpec.describe "Auth", type: :request do
  describe "POST /api/v1/auth/register" do
    it "creates a user account and returns a JWT" do
      post "/api/v1/auth/register", params: {
        user: {
          name: "New Shopper",
          email: "shopper@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }, as: :json

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["token"]).to be_present
      expect(response.parsed_body.dig("user", "email")).to eq("shopper@example.com")
      expect(response.parsed_body.dig("user", "role")).to eq("user")
      expect(User.find_by(email: "shopper@example.com")).to be_user
    end

    it "does not allow registering as an admin" do
      post "/api/v1/auth/register", params: {
        user: {
          name: "Hacker",
          email: "hacker@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "admin"
        }
      }, as: :json

      expect(response).to have_http_status(:created)
      expect(User.find_by(email: "hacker@example.com")).to be_user
    end
  end

  describe "POST /api/v1/auth/login" do
    it "returns a token for valid credentials" do
      post "/api/v1/auth/login", params: { email: "admin@example.com", password: "password123" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["token"]).to be_present
      expect(response.parsed_body.dig("user", "role")).to eq("admin")
    end

    it "rejects invalid credentials" do
      post "/api/v1/auth/login", params: { email: "admin@example.com", password: "nope" }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/profile" do
    it "requires a token" do
      get "/api/v1/profile", as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns the current user" do
      get "/api/v1/profile", headers: auth_headers(users(:jane)), as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["email"]).to eq("jane@example.com")
    end
  end
end
