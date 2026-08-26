class Order < ApplicationRecord
  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :variants, through: :order_items

  enum :status, {
    pending: "pending",
    paid: "paid",
    shipped: "shipped",
    delivered: "delivered",
    cancelled: "cancelled"
  }, default: :pending, validate: true

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :customer_name, with: ->(name) { name.strip }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_name, presence: true
  validates :shipping_address, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :assign_customer_from_user, on: :create

  private

  def assign_customer_from_user
    return unless user

    self.email = user.email if email.blank?
    self.customer_name = user.name if customer_name.blank?
  end
end
