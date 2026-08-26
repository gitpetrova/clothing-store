require "rails_helper"

RSpec.describe Variant, type: :model do
  it "belongs to a product" do
    variant = variants(:classic_tee_small_black)

    expect(variant.product).to eq(products(:classic_tee))
    expect(products(:classic_tee).variants).to include(variant)
  end

  it "rejects a duplicate size and color on the same product" do
    existing = variants(:classic_tee_small_black)
    duplicate = existing.product.variants.build(
      sku: "TEE-S-BLK-2",
      size: existing.size,
      color: existing.color,
      price: 29,
      stock: 1
    )

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:size]).to include("and color combination already exists for this product")
  end

  it "reports whether it is in stock" do
    variant = variants(:classic_tee_small_black)

    expect(variant).to be_in_stock

    variant.update!(stock: 0)
    expect(variant).not_to be_in_stock
  end
end
