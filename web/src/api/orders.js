import http from "@/api/http"

export async function createOrder(order) {
  const { data } = await http.post("/orders", { order })
  return data
}
