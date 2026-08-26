class ProductImageSerializer < ApplicationSerializer
  def initialize(image)
    @image = image
  end

  def as_json(*)
    return if @image.nil?

    {
      id: @image.id,
      url: @image.url,
      alt_text: @image.alt_text,
      position: @image.position,
      variant_id: @image.variant_id
    }
  end
end
