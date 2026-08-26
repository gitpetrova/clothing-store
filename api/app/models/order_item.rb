class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :variant

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :product_name, presence: true
  validates :size, presence: true
  validates :color, presence: true

  before_validation :snapshot_variant_details, on: :create

  def line_total
    return if unit_price.blank? || quantity.blank?

    unit_price * quantity
  end

  private

  def snapshot_variant_details
    return unless variant

    self.product_name = variant.product.name if product_name.blank?
    self.size = variant.size if size.blank?
    self.color = variant.color if color.blank?
    self.unit_price = variant.price if unit_price.blank?
  end
end
