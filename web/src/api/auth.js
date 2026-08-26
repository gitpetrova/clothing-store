import http from "@/api/http"
import { clearSession, getToken, setSession, setUser } from "@/auth/session"

export async function login(email, password) {
  const { data } = await http.post("/auth/login", { email, password })
  setSession(data)
  return data
}

export async function register(user) {
  const { data } = await http.post("/auth/register", { user })
  setSession(data)
  return data
}

export async function fetchProfile() {
  const { data } = await http.get("/profile")
  setUser(data)
  return data
}

export async function restoreSession() {
  if (!getToken()) return null

  try {
    return await fetchProfile()
  } catch {
    clearSession()
    return null
  }
}

export function logout() {
  clearSession()
}
