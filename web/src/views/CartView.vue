<script setup>
import { ref } from "vue"
import { RouterLink } from "vue-router"
import { createOrder } from "@/api/orders"
import { cartCount, cartItems, cartSubtotal, clearCart, removeFromCart, setCartQuantity } from "@/cart/store"

const currency = new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" })
const shippingAddress = ref("")
const saving = ref(false)
const error = ref("")
const confirmation = ref(null)

function money(value) {
  return currency.format(Number(value))
}

async function checkout() {
  if (!cartItems.value.length || !shippingAddress.value.trim()) return

  saving.value = true
  error.value = ""
  confirmation.value = null

  try {
    const order = await createOrder({
      shipping_address: shippingAddress.value.trim(),
      items: cartItems.value.map((item) => ({
        variant_id: item.variantId,
        quantity: item.quantity,
      })),
    })
    clearCart()
    confirmation.value = order
    shippingAddress.value = ""
  } catch (err) {
    error.value = err.message
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <section class="panel">
    <h2>Cart</h2>
    <p class="muted">{{ cartCount }} {{ cartCount === 1 ? "item" : "items" }} · stored until you place an order.</p>

    <p v-if="error" class="banner">{{ error }}</p>
    <p v-if="confirmation" class="success">
      Order #{{ confirmation.id }} placed · {{ money(confirmation.total) }} · {{ confirmation.status }}
    </p>

    <p v-if="!cartItems.length && !confirmation" class="muted">
      Your cart is empty.
      <RouterLink :to="{ name: 'products' }">Browse products</RouterLink>
    </p>

    <ul v-else-if="cartItems.length" class="lines">
      <li v-for="item in cartItems" :key="item.variantId">
        <div class="thumb">
          <img v-if="item.imageUrl" :src="item.imageUrl" :alt="item.productName" />
        </div>
        <div class="body">
          <RouterLink :to="{ name: 'product', params: { id: item.productId } }">{{ item.productName }}</RouterLink>
          <p>{{ item.color }} · {{ item.size }} · {{ item.sku }}</p>
          <p>{{ money(item.price) }}</p>
        </div>
        <div class="qty">
          <input
            :value="item.quantity"
            type="number"
            min="1"
            :max="item.stock"
            @change="setCartQuantity(item.variantId, $event.target.value)"
          />
          <button type="button" class="ghost" @click="removeFromCart(item.variantId)">Remove</button>
        </div>
        <p class="line-total">{{ money(Number(item.price) * item.quantity) }}</p>
      </li>
    </ul>

    <form v-if="cartItems.length" class="checkout" @submit.prevent="checkout">
      <p class="total">Subtotal {{ money(cartSubtotal) }}</p>
      <label>
        Shipping address
        <textarea v-model="shippingAddress" rows="3" required placeholder="Street, city, postal code" />
      </label>
      <button type="submit" :disabled="saving">{{ saving ? "Placing order…" : "Place order" }}</button>
    </form>
  </section>
</template>

<style scoped>
.panel {
  background: var(--paper);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  padding: 22px;
  display: grid;
  gap: 16px;
}

h2 {
  font-family: "Fraunces", Georgia, serif;
  font-size: 1.8rem;
  font-weight: 560;
}

.muted {
  color: var(--muted);
  font-size: 0.92rem;
}

.muted a,
.body a {
  color: var(--ink);
  font-weight: 600;
  text-decoration: none;
}

.banner {
  background: #fff1f2;
  color: #9f1239;
  padding: 10px 12px;
  border-radius: 10px;
}

.success {
  background: #ecfccb;
  color: #3f6212;
  padding: 10px 12px;
  border-radius: 10px;
}

.lines {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 12px;
}

li {
  display: grid;
  grid-template-columns: 72px 1fr auto auto;
  gap: 14px;
  align-items: center;
  padding: 12px;
  border: 1px solid var(--line);
  border-radius: 12px;
}

.thumb {
  width: 72px;
  height: 90px;
  background: #ece7dc;
  border-radius: 8px;
  overflow: hidden;
}

.thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.body p,
.line-total {
  color: var(--muted);
  font-size: 0.9rem;
}

.qty {
  display: grid;
  gap: 6px;
  justify-items: start;
}

.qty input {
  width: 64px;
  border: 1px solid var(--line);
  border-radius: 10px;
  padding: 6px 8px;
}

.ghost {
  background: transparent;
  border: 0;
  color: var(--muted);
  padding: 0;
  font-size: 0.86rem;
}

.line-total {
  font-weight: 650;
  color: var(--ink);
}

.checkout {
  display: grid;
  gap: 12px;
  padding-top: 8px;
}

.total {
  font-size: 1.15rem;
  font-weight: 650;
}

label {
  display: grid;
  gap: 6px;
  font-weight: 600;
  font-size: 0.92rem;
}

textarea {
  width: 100%;
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 10px 12px;
  background: #fff;
  font-weight: 400;
}

.checkout button {
  justify-self: start;
  background: var(--ink);
  color: #fff;
  border: 0;
  border-radius: 999px;
  padding: 8px 16px;
  font-weight: 600;
}

.checkout button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

@media (max-width: 700px) {
  li {
    grid-template-columns: 72px 1fr;
  }

  .qty,
  .line-total {
    grid-column: 2;
  }
}
</style>
