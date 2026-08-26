import { computed, reactive } from "vue"

const CART_KEY = "clothing_store_cart"

function readCart() {
  try {
    const rows = JSON.parse(localStorage.getItem(CART_KEY) || "[]")
    return Array.isArray(rows) ? rows : []
  } catch {
    return []
  }
}

const state = reactive({
  items: readCart(),
})

function persist() {
  localStorage.setItem(CART_KEY, JSON.stringify(state.items))
}

export const cartItems = computed(() => state.items)

export const cartCount = computed(() =>
  state.items.reduce((total, item) => total + item.quantity, 0),
)

export const cartSubtotal = computed(() =>
  state.items.reduce((total, item) => total + Number(item.price) * item.quantity, 0),
)

export function addToCart({ product, variant, imageUrl }, quantity = 1) {
  if (!variant?.id || !variant.in_stock) return

  const existing = state.items.find((item) => item.variantId === variant.id)
  const nextQuantity = Math.min((existing?.quantity || 0) + quantity, variant.stock)

  if (existing) {
    existing.quantity = nextQuantity
    existing.stock = variant.stock
    existing.price = variant.price
  } else {
    state.items.push({
      variantId: variant.id,
      productId: product.id,
      productName: product.name,
      sku: variant.sku,
      size: variant.size,
      color: variant.color,
      price: variant.price,
      stock: variant.stock,
      quantity: nextQuantity,
      imageUrl: imageUrl || product.primary_image?.url || null,
    })
  }

  persist()
}

export function setCartQuantity(variantId, quantity) {
  const item = state.items.find((row) => row.variantId === variantId)
  if (!item) return

  const next = Math.max(1, Math.min(Number(quantity) || 1, item.stock))
  item.quantity = next
  persist()
}

export function removeFromCart(variantId) {
  state.items = state.items.filter((item) => item.variantId !== variantId)
  persist()
}

export function clearCart() {
  state.items = []
  persist()
}
