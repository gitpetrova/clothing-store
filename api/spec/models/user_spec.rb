require "rails_helper"

RSpec.describe User, type: :model do
  it "authenticates with a password" do
    expect(users(:jane).authenticate("password123")).to eq(users(:jane))
    expect(users(:jane).authenticate("wrong")).to be(false)
  end

  it "defaults new accounts to the user role" do
    user = User.create!(name: "Riley", email: "riley@example.com", password: "password123")

    expect(user).to be_user
    expect(user).not_to be_admin
  end

  it "does not include the password digest in JSON" do
    expect(users(:admin).as_json).to include("email" => "admin@example.com", "role" => "admin")
    expect(users(:admin).as_json).not_to have_key("password_digest")
  end
end
