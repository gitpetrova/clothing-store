class Variant < ApplicationRecord
  belongs_to :product

  has_many :order_items, dependent: :restrict_with_error
  has_many :product_images, dependent: :nullify

  normalizes :sku, with: ->(sku) { sku.strip.upcase }
  normalizes :size, with: ->(size) { size.strip }
  normalizes :color, with: ->(color) { color.strip }

  validates :sku, presence: true, uniqueness: true
  validates :size, presence: true
  validates :color, presence: true
  validates :size, uniqueness: { scope: [ :product_id, :color ], message: "and color combination already exists for this product" }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def in_stock?
    stock.positive?
  end
end
