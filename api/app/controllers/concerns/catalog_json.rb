module CatalogJson
  extend ActiveSupport::Concern

  private

  def category_json(category)
    ::CategorySerializer.new(category).as_json
  end

  def product_json(product)
    ::ProductSerializer.new(product).as_json
  end

  def variant_json(variant)
    ::VariantSerializer.new(variant).as_json
  end

  def product_image_json(image)
    ::ProductImageSerializer.new(image).as_json
  end

  def order_json(order)
    order.as_json(
      only: [ :id, :user_id, :email, :customer_name, :shipping_address, :status, :total, :created_at, :updated_at ],
      include: {
        order_items: { only: [ :id, :variant_id, :quantity, :unit_price, :product_name, :size, :color ] }
      }
    )
  end
end
