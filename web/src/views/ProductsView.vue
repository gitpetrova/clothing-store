<script setup>
import { computed, onMounted, ref } from "vue"
import { RouterLink } from "vue-router"
import { listCategories, listProducts } from "@/api/catalog"

const products = ref([])
const categories = ref([])
const categoryId = ref("")
const loading = ref(true)
const error = ref("")

const currency = new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" })

function formatPrice(product) {
  if (!product.price_from) return "—"
  if (product.price_from === product.price_to) return currency.format(Number(product.price_from))
  return `${currency.format(Number(product.price_from))} – ${currency.format(Number(product.price_to))}`
}

const visibleProducts = computed(() => products.value)

async function load() {
  loading.value = true
  error.value = ""
  try {
    const [categoryRows, productRows] = await Promise.all([
      listCategories(),
      listProducts(categoryId.value || undefined),
    ])
    categories.value = categoryRows
    products.value = productRows
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

async function filterBy(id) {
  categoryId.value = id
  await load()
}

onMounted(load)
</script>

<template>
  <section>
    <div class="toolbar">
      <button type="button" :class="{ active: !categoryId }" @click="filterBy('')">All</button>
      <button
        v-for="category in categories"
        :key="category.id"
        type="button"
        :class="{ active: String(categoryId) === String(category.id) }"
        @click="filterBy(category.id)"
      >
        {{ category.name }}
      </button>
    </div>

    <p v-if="error" class="banner">{{ error }}</p>
    <p v-else-if="loading" class="muted">Loading the rack…</p>
    <p v-else-if="!visibleProducts.length" class="muted">No pieces in this category yet.</p>

    <ul v-else class="grid">
      <li v-for="product in visibleProducts" :key="product.id">
        <RouterLink :to="{ name: 'product', params: { id: product.id } }" class="card">
          <div class="photo">
            <img
              v-if="product.primary_image?.url"
              :src="product.primary_image.url"
              :alt="product.primary_image.alt_text || product.name"
            />
          </div>
          <div class="meta">
            <p class="category">{{ product.category?.name }}</p>
            <h2>{{ product.name }}</h2>
            <p class="price">{{ formatPrice(product) }}</p>
            <p class="stock" :class="{ out: !product.in_stock }">
              {{ product.in_stock ? "In stock" : "Sold out" }}
            </p>
          </div>
        </RouterLink>
      </li>
    </ul>
  </section>
</template>

<style scoped>
.toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 22px;
}

.toolbar button {
  border: 1px solid var(--line);
  background: var(--paper);
  color: var(--muted);
  border-radius: 999px;
  padding: 6px 14px;
  font-weight: 600;
  font-size: 0.88rem;
}

.toolbar button.active {
  background: var(--ink);
  border-color: var(--ink);
  color: #fff;
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

.grid {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 18px;
}

.card {
  display: grid;
  text-decoration: none;
  color: inherit;
  background: var(--paper);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  overflow: hidden;
  box-shadow: var(--shadow);
}

.photo {
  aspect-ratio: 4 / 5;
  background: #ece7dc;
}

.photo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.meta {
  padding: 14px;
  display: grid;
  gap: 4px;
}

.category {
  color: var(--accent);
  font-size: 0.72rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  font-weight: 600;
}

h2 {
  font-size: 1.05rem;
  font-weight: 650;
}

.price {
  font-weight: 600;
}

.stock {
  color: var(--done);
  font-size: 0.86rem;
}

.stock.out {
  color: var(--muted);
}
</style>
