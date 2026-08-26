class Product < ApplicationRecord
  belongs_to :category

  has_many :variants, dependent: :destroy
  has_many :product_images, dependent: :destroy
  has_many :order_items, through: :variants

  normalizes :name, with: ->(name) { name.strip }
  normalizes :slug, with: ->(slug) { slug.strip.downcase }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
