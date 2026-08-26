import axios from "axios"

const baseURL = process.env.API_BASE || "http://127.0.0.1:5173/api/v1"
let token = null

const http = axios.create({
  baseURL,
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
})

http.interceptors.request.use((config) => {
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

async function main() {
  console.log(`Using ${baseURL}`)

  const categories = await http.get("/categories")
  console.log(`GET /categories -> ${categories.status} (${categories.data.length} categories)`)

  try {
    await http.get("/products")
    console.error("GET /products unexpectedly succeeded without a token")
    process.exit(1)
  } catch (error) {
    console.log(`GET /products (no token) -> ${error.response?.status} ${error.response?.data?.error}`)
  }

  const login = await http.post("/auth/login", {
    email: "user@example.com",
    password: "password123",
  })
  token = login.data.token
  console.log(`POST /auth/login -> ${login.status} role=${login.data.user.role}`)

  const profile = await http.get("/profile")
  console.log(`GET /profile -> ${profile.status} ${profile.data.email} (Authorization attached)`)

  const products = await http.get("/products")
  console.log(`GET /products -> ${products.status} (${products.data.length} products)`)
  const first = products.data[0]
  if (first) {
    const show = await http.get(`/products/${first.id}`)
    console.log(`GET /products/${first.id} -> ${show.status} ${show.data.name} (${show.data.variants.length} variants)`)
  }

  try {
    await http.get("/admin/users")
    console.error("GET /admin/users unexpectedly succeeded")
    process.exit(1)
  } catch (error) {
    console.log(`GET /admin/users -> ${error.response?.status} ${error.response?.data?.error}`)
  }

  console.log("Frontend can talk to the Rails API through the Vite proxy.")
}

main().catch((error) => {
  console.error("API smoke test failed.")
  console.error(error.response?.data || error.message)
  console.error("Start Rails on :3000 and Vite on :5173, then retry.")
  process.exit(1)
})
