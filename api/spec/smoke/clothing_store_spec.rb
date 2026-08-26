require "rails_helper"

RSpec.describe "clothing store domain", type: :model do
  it "nests products under a category" do
    expect(categories(:tops).products).to include(products(:classic_tee))
    expect(products(:classic_tee).category).to eq(categories(:tops))
    expect(categories(:bottoms).products).to include(products(:slim_chinos))
  end

  it "gives a product many variants and images" do
    product = products(:classic_tee)

    expect(product.variants).to include(
      variants(:classic_tee_small_black),
      variants(:classic_tee_medium_black)
    )
    expect(product.product_images).to include(
      product_images(:classic_tee_front),
      product_images(:classic_tee_black)
    )
    expect(product_images(:classic_tee_front).variant).to be_nil
    expect(product_images(:classic_tee_black).variant).to eq(variants(:classic_tee_small_black))
  end

  it "places an order for a variant and snapshots catalog details" do
    order = orders(:pending_order)
    item = order_items(:pending_tee)
    variant = variants(:classic_tee_small_black)

    expect(order.order_items).to include(item)
    expect(order.variants).to include(variant)
    expect(products(:classic_tee).order_items).to include(item)
    expect(item.product_name).to eq("Classic Tee")
    expect(item.size).to eq("S")
    expect(item.color).to eq("Black")
    expect(item.unit_price).to eq(29)
    expect(item.line_total).to eq(58)
  end

  it "does not destroy a variant that appears on an order" do
    variant = variants(:classic_tee_small_black)

    expect(variant.destroy).to be(false)
    expect(Variant).to exist(variant.id)
  end

  it "does not destroy a category that still has products" do
    category = categories(:tops)

    expect(category.destroy).to be(false)
    expect(Category).to exist(category.id)
  end
end
