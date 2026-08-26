class ProductImage < ApplicationRecord
  belongs_to :product
  belongs_to :variant, optional: true

  validates :url, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :variant_belongs_to_product

  private

  def variant_belongs_to_product
    return if variant.blank? || product.blank?
    return if variant.product_id == product_id

    errors.add(:variant, "must belong to the same product")
  end
end
