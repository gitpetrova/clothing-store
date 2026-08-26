class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  normalizes :name, with: ->(name) { name.strip }
  normalizes :slug, with: ->(slug) { slug.strip.downcase }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
