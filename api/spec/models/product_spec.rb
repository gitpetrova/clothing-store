require "rails_helper"

RSpec.describe Product, type: :model do
  it "belongs to a category and has many variants" do
    product = products(:classic_tee)

    expect(product.category).to eq(categories(:tops))
    expect(categories(:tops).products).to include(product)
    expect(product.variants).to include(
      variants(:classic_tee_small_black),
      variants(:classic_tee_medium_black)
    )
    expect(variants(:classic_tee_small_black).product).to eq(product)
  end

  it "generates a unique slug from the name" do
    product = categories(:tops).products.create!(name: "Linen Shirt")

    expect(product.slug).to eq("linen-shirt")
    expect(product).to be_persisted
  end

  it "destroys its variants when the product is destroyed" do
    product = categories(:tops).products.create!(name: "Seasonal Tank")
    product.variants.create!(sku: "TANK-S-WHT", size: "S", color: "White", price: 19, stock: 4)

    expect { product.destroy! }.to change(Variant, :count).by(-1)
  end
end
