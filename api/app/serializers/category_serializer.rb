class CategorySerializer < ApplicationSerializer
  def initialize(category)
    @category = category
  end

  def as_json(*)
    return if @category.nil?

    {
      id: @category.id,
      name: @category.name,
      slug: @category.slug,
      description: @category.description
    }
  end
end
