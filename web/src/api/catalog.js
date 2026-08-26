import http from "@/api/http"

export async function listCategories() {
  const { data } = await http.get("/categories")
  return data
}

export async function listProducts(categoryId) {
  const { data } = await http.get("/products", {
    params: categoryId ? { category_id: categoryId } : undefined,
  })
  return data
}

export async function getProduct(id) {
  const { data } = await http.get(`/products/${id}`)
  return data
}

export async function listProductVariants(productId) {
  const { data } = await http.get(`/products/${productId}/variants`)
  return data
}

export async function getVariant(id) {
  const { data } = await http.get(`/variants/${id}`)
  return data
}
