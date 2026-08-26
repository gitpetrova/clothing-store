class VariantSerializer < ApplicationSerializer
  def initialize(variant)
    @variant = variant
  end

  def as_json(*)
    {
      id: @variant.id,
      product_id: @variant.product_id,
      sku: @variant.sku,
      size: @variant.size,
      color: @variant.color,
      price: money(@variant.price),
      stock: @variant.stock,
      in_stock: @variant.in_stock?
    }
  end
end
