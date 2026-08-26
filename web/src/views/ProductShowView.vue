<script setup>
import { computed, onMounted, ref, watch } from "vue"
import { RouterLink, useRoute } from "vue-router"
import { getProduct } from "@/api/catalog"
import { addToCart } from "@/cart/store"

const route = useRoute()
const product = ref(null)
const selectedColor = ref("")
const selectedSize = ref("")
const loading = ref(true)
const error = ref("")
const notice = ref("")

const currency = new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" })

const colors = computed(() => product.value?.colors || [])
const sizes = computed(() => {
  if (!product.value) return []
  return product.value.variants
    .filter((variant) => variant.color === selectedColor.value)
    .map((variant) => variant.size)
})

const selectedVariant = computed(() => {
  if (!product.value) return null
  return product.value.variants.find(
    (variant) => variant.color === selectedColor.value && variant.size === selectedSize.value,
  )
})

const heroImage = computed(() => {
  const images = product.value?.images || []
  const forVariant = images.find((image) => image.variant_id === selectedVariant.value?.id)
  return forVariant || product.value?.primary_image || images[0]
})

function money(value) {
  return currency.format(Number(value))
}

function selectFirstAvailable() {
  const available = product.value?.variants.find((variant) => variant.in_stock) || product.value?.variants[0]
  if (!available) return
  selectedColor.value = available.color
  selectedSize.value = available.size
}

function onAddToCart() {
  if (!selectedVariant.value?.in_stock) return
  addToCart({
    product: product.value,
    variant: selectedVariant.value,
    imageUrl: heroImage.value?.url,
  })
  notice.value = `${product.value.name} · ${selectedVariant.value.color} · ${selectedVariant.value.size} added to cart`
}

watch(selectedColor, (color) => {
  if (!product.value) return
  const match = product.value.variants.find((variant) => variant.color === color && variant.size === selectedSize.value)
  if (match) return
  const fallback = product.value.variants.find((variant) => variant.color === color)
  if (fallback) selectedSize.value = fallback.size
})

onMounted(async () => {
  try {
    product.value = await getProduct(route.params.id)
    selectFirstAvailable()
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <section>
    <p class="back">
      <RouterLink :to="{ name: 'products' }">← All products</RouterLink>
    </p>

    <p v-if="error" class="banner">{{ error }}</p>
    <p v-else-if="loading" class="muted">Loading product…</p>

    <article v-else-if="product" class="layout">
      <div class="photo">
        <img
          v-if="heroImage?.url"
          :src="heroImage.url"
          :alt="heroImage.alt_text || product.name"
        />
      </div>

      <div class="details">
        <p class="category">{{ product.category?.name }}</p>
        <h2>{{ product.name }}</h2>
        <p class="description">{{ product.description }}</p>

        <p class="price">
          {{ selectedVariant ? money(selectedVariant.price) : money(product.price_from) }}
        </p>

        <div v-if="colors.length" class="picker">
          <p>Color</p>
          <div class="row">
            <button
              v-for="color in colors"
              :key="color"
              type="button"
              :class="{ active: selectedColor === color }"
              @click="selectedColor = color"
            >
              {{ color }}
            </button>
          </div>
        </div>

        <div v-if="sizes.length" class="picker">
          <p>Size</p>
          <div class="row">
            <button
              v-for="size in sizes"
              :key="size"
              type="button"
              :class="{ active: selectedSize === size }"
              @click="selectedSize = size"
            >
              {{ size }}
            </button>
          </div>
        </div>

        <p v-if="selectedVariant" class="stock" :class="{ out: !selectedVariant.in_stock }">
          <template v-if="selectedVariant.in_stock">
            {{ selectedVariant.sku }} · {{ selectedVariant.stock }} in stock
          </template>
          <template v-else>Sold out in this size</template>
        </p>

        <button
          type="button"
          class="add"
          :disabled="!selectedVariant?.in_stock"
          @click="onAddToCart"
        >
          {{ selectedVariant?.in_stock ? "Add to cart" : "Sold out" }}
        </button>
        <p v-if="notice" class="notice">
          {{ notice }}
          <RouterLink :to="{ name: 'cart' }">View cart</RouterLink>
        </p>
      </div>
    </article>
  </section>
</template>

<style scoped>
.back {
  margin-bottom: 18px;
}

.back a {
  color: var(--muted);
  text-decoration: none;
  font-weight: 600;
  font-size: 0.92rem;
}

.banner {
  background: #fff1f2;
  color: #9f1239;
  padding: 10px 12px;
  border-radius: 10px;
}

.muted {
  color: var(--muted);
}

.layout {
  display: grid;
  grid-template-columns: minmax(0, 1.1fr) minmax(0, 0.9fr);
  gap: 28px;
  background: var(--paper);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  overflow: hidden;
}

.photo {
  min-height: 420px;
  background: #ece7dc;
}

.photo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.details {
  padding: 28px;
  display: grid;
  align-content: start;
  gap: 10px;
}

.category {
  color: var(--accent);
  font-size: 0.72rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  font-weight: 600;
}

h2 {
  font-family: "Fraunces", Georgia, serif;
  font-size: 2rem;
  font-weight: 560;
}

.description {
  color: var(--muted);
}

.price {
  font-size: 1.2rem;
  font-weight: 650;
}

.picker p {
  font-size: 0.78rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--muted);
  font-weight: 600;
  margin-bottom: 8px;
}

.row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.row button {
  border: 1px solid var(--line);
  background: #fff;
  border-radius: 999px;
  padding: 6px 12px;
  font-weight: 600;
}

.row button.active {
  background: var(--ink);
  border-color: var(--ink);
  color: #fff;
}

.stock {
  color: var(--done);
  font-size: 0.92rem;
}

.stock.out {
  color: #9f1239;
}

.add {
  justify-self: start;
  margin-top: 8px;
  background: var(--ink);
  color: #fff;
  border: 0;
  border-radius: 999px;
  padding: 10px 18px;
  font-weight: 600;
}

.add:disabled {
  opacity: 0.45;
  cursor: not-allowed;
}

.notice {
  color: var(--done);
  font-size: 0.92rem;
}

.notice a {
  color: var(--ink);
  font-weight: 600;
}

@media (max-width: 800px) {
  .layout {
    grid-template-columns: 1fr;
  }

  .details {
    padding: 8px 18px 24px;
  }

  .photo {
    min-height: 280px;
  }
}
</style>
