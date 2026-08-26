class User < ApplicationRecord
  has_secure_password

  has_many :orders, dependent: :restrict_with_error

  enum :role, { user: "user", admin: "admin" }, default: :user, validate: true

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :name, with: ->(name) { name.strip }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true

  def as_json(options = {})
    super({ only: [ :id, :name, :email, :role, :created_at, :updated_at ] }.merge(options))
  end
end
