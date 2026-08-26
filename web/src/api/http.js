import axios from "axios"
import { clearSession, getToken } from "@/auth/session"

const http = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || "/api/v1",
  timeout: 15000,
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
})

http.interceptors.request.use((config) => {
  const token = getToken()
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

http.interceptors.response.use(
  (response) => response,
  async (error) => {
    const status = error.response?.status
    const url = error.config?.url || ""
    const isAuthRequest = url.includes("/auth/login") || url.includes("/auth/register")

    if (status === 401 && !isAuthRequest) {
      clearSession()
      const { default: router } = await import("@/router")
      if (router.currentRoute.value.name !== "login") {
        await router.push({ name: "login", query: { redirect: router.currentRoute.value.fullPath } })
      }
    }

    const data = error.response?.data
    const message = data?.errors?.join(", ") || data?.error || error.message || `Request failed (${status})`
    return Promise.reject(new Error(message))
  },
)

export default http
