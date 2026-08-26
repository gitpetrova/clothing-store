admin = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name = "Store Admin"
  user.password = "password123"
  user.role = :admin
end
admin.update!(role: :admin) unless admin.admin?

User.find_or_create_by!(email: "user@example.com") do |user|
  user.name = "Jane Doe"
  user.password = "password123"
  user.role = :user
end

Item.find_or_create_by!(title: "Wire the Vue app to Rails") do |item|
  item.description = "The frontend calls GET /api/v1/items through the Vite proxy."
  item.completed = true
end

Item.find_or_create_by!(title: "Add your own resource") do |item|
  item.description = "Copy the items pattern: model, controller, route, then a Vue view."
  item.completed = false
end

Item.find_or_create_by!(title: "Ship something real") do |item|
  item.description = "Replace this starter with the product you actually want."
  item.completed = false
end

def seed_category(name, description)
  category = Category.find_or_initialize_by(slug: name.parameterize)
  category.name = name
  category.description = description
  category.save!
  category
end

def seed_product(category:, name:, description:, image_url:, variants:)
  product = Product.find_or_initialize_by(slug: name.parameterize)
  product.assign_attributes(category: category, name: name, description: description)
  product.save!

  unless product.product_images.exists?(position: 0)
    product.product_images.create!(url: image_url, alt_text: name, position: 0)
  end

  variants.each do |attrs|
    variant = product.variants.find_or_initialize_by(size: attrs[:size], color: attrs[:color])
    variant.assign_attributes(attrs)
    variant.save!
  end

  product
end

tops = seed_category("Tops", "Tees, shirts, and knits")
bottoms = seed_category("Bottoms", "Trousers, denim, and shorts")
outerwear = seed_category("Outerwear", "Jackets and coats")
accessories = seed_category("Accessories", "Scarves and extras")

seed_product(
  category: tops,
  name: "Classic Cotton Tee",
  description: "A midweight crewneck in combed cotton. Cut to sit clean at the shoulder with a slightly relaxed body.",
  image_url: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=80",
  variants: [
    { sku: "TEE-S-WHT", size: "S", color: "White", price: 32, stock: 18 },
    { sku: "TEE-M-WHT", size: "M", color: "White", price: 32, stock: 24 },
    { sku: "TEE-L-WHT", size: "L", color: "White", price: 32, stock: 12 },
    { sku: "TEE-S-BLK", size: "S", color: "Black", price: 32, stock: 10 },
    { sku: "TEE-M-BLK", size: "M", color: "Black", price: 32, stock: 16 },
    { sku: "TEE-L-BLK", size: "L", color: "Black", price: 32, stock: 9 }
  ]
)

seed_product(
  category: tops,
  name: "Linen Camp Shirt",
  description: "A breathable camp collar shirt in washed linen. Wear it open over a tee or closed on its own.",
  image_url: "https://images.unsplash.com/photo-1596755094514-f87e34085b85?auto=format&fit=crop&w=900&q=80",
  variants: [
    { sku: "SHIRT-S-SND", size: "S", color: "Sand", price: 78, stock: 8 },
    { sku: "SHIRT-M-SND", size: "M", color: "Sand", price: 78, stock: 11 },
    { sku: "SHIRT-L-SND", size: "L", color: "Sand", price: 78, stock: 6 },
    { sku: "SHIRT-M-BLU", size: "M", color: "Sky", price: 78, stock: 7 },
    { sku: "SHIRT-L-BLU", size: "L", color: "Sky", price: 78, stock: 4 }
  ]
)

seed_product(
  category: tops,
  name: "Heavyweight Hoodie",
  description: "Brushed fleece with a double-layer hood and ribbed cuffs. The everyday layer for cool mornings.",
  image_url: "https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=900&q=80",
  variants: [
    { sku: "HOOD-S-CHR", size: "S", color: "Charcoal", price: 96, stock: 7 },
    { sku: "HOOD-M-CHR", size: "M", color: "Charcoal", price: 96, stock: 13 },
    { sku: "HOOD-L-CHR", size: "L", color: "Charcoal", price: 96, stock: 8 },
    { sku: "HOOD-M-CRM", size: "M", color: "Cream", price: 96, stock: 5 },
    { sku: "HOOD-L-CRM", size: "L", color: "Cream", price: 96, stock: 3 }
  ]
)

seed_product(
  category: bottoms,
  name: "Slim Chinos",
  description: "Stretch cotton twill with a tapered leg. Dress them up with a shirt or down with a tee.",
  image_url: "https://images.unsplash.com/photo-1473966968600-fa801b869a1a?auto=format&fit=crop&w=900&q=80",
  variants: [
    { sku: "CHINO-30-KHK", size: "30", color: "Khaki", price: 88, stock: 6 },
    { sku: "CHINO-32-KHK", size: "32", color: "Khaki", price: 88, stock: 14 },
    { sku: "CHINO-34-KHK", size: "34", color: "Khaki", price: 88, stock: 9 },
    { sku: "CHINO-32-NAV", size: "32", color: "Navy", price: 88, stock: 8 },
    { sku: "CHINO-34-NAV", size: "34", color: "Navy", price: 88, stock: 5 }
  ]
)

seed_product(
  category: bottoms,
  name: "Straight Indigo Jeans",
  description: "A classic straight cut in 13oz Japanese denim. They start structured and soften with wear.",
  image_url: "https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&w=900&q=80",
  variants: [
    { sku: "JEAN-30-IND", size: "30", color: "Indigo", price: 128, stock: 4 },
    { sku: "JEAN-32-IND", size: "32", color: "Indigo", price: 128, stock: 10 },
    { sku: "JEAN-34-IND", size: "34", color: "Indigo", price: 128, stock: 7 },
    { sku: "JEAN-36-IND", size: "36", color: "Indigo", price: 128, stock: 3 }
  ]
)

seed_product(
  category: outerwear,
  name: "Wool Overcoat",
  description: "A knee-length coat in Italian wool blend, with a notched lapel and a single-breasted close.",
  image_url: "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?auto=format&fit=crop&w=900&q=80",
  variants: [
    { sku: "COAT-S-CML", size: "S", color: "Camel", price: 320, stock: 2 },
    { sku: "COAT-M-CML", size: "M", color: "Camel", price: 320, stock: 4 },
    { sku: "COAT-L-CML", size: "L", color: "Camel", price: 320, stock: 3 },
    { sku: "COAT-M-BLK", size: "M", color: "Black", price: 320, stock: 3 },
    { sku: "COAT-L-BLK", size: "L", color: "Black", price: 320, stock: 2 }
  ]
)

seed_product(
  category: outerwear,
  name: "Washed Denim Jacket",
  description: "A vintage-wash trucker with copper hardware and a broken-in hand from the first wear.",
  image_url: "https://images.unsplash.com/photo-1551537482-f2075a1d41f2?auto=format&fit=crop&w=900&q=80",
  variants: [
    { sku: "DENIM-S-WSH", size: "S", color: "Wash", price: 148, stock: 5 },
    { sku: "DENIM-M-WSH", size: "M", color: "Wash", price: 148, stock: 9 },
    { sku: "DENIM-L-WSH", size: "L", color: "Wash", price: 148, stock: 6 }
  ]
)

seed_product(
  category: accessories,
  name: "Merino Scarf",
  description: "Fine merino, lightly felted at the ends. Long enough to wrap once and still hang clean.",
  image_url: "https://images.unsplash.com/photo-1520903920243-00d872a2d1c9?auto=format&fit=crop&w=900&q=80",
  variants: [
    { sku: "SCARF-OS-FOR", size: "One size", color: "Forest", price: 54, stock: 12 },
    { sku: "SCARF-OS-RST", size: "One size", color: "Rust", price: 54, stock: 8 }
  ]
)
