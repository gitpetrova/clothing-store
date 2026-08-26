class ProductSerializer < ApplicationSerializer
  def initialize(product)
    @product = product
  end

  def as_json(*)
    {
      id: @product.id,
      name: @product.name,
      slug: @product.slug,
      description: @product.description,
      category: CategorySerializer.new(@product.category).as_json,
      price_from: money(prices.min),
      price_to: money(prices.max),
      in_stock: variants.any?(&:in_stock?),
      sizes: variants.map(&:size).uniq,
      colors: variants.map(&:color).uniq,
      primary_image: ProductImageSerializer.new(primary_image).as_json,
      variants: variants.sort_by { |variant| [ variant.size, variant.color ] }.map { |variant|
        VariantSerializer.new(variant).as_json
      },
      images: images.map { |image| ProductImageSerializer.new(image).as_json },
      created_at: @product.created_at,
      updated_at: @product.updated_at
    }
  end

  private

  def variants
    @variants ||= @product.variants.to_a
  end

  def images
    @images ||= @product.product_images.sort_by(&:position)
  end

  def prices
    variants.map(&:price)
  end

  def primary_image
    images.first
  end
end
