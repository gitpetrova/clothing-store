import http from "@/api/http"

export async function listItems() {
  const { data } = await http.get("/items")
  return data
}

export async function createItem(item) {
  const { data } = await http.post("/items", { item })
  return data
}

export async function updateItem(id, item) {
  const { data } = await http.patch(`/items/${id}`, { item })
  return data
}

export async function deleteItem(id) {
  await http.delete(`/items/${id}`)
}
