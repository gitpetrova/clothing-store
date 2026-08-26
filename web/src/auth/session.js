import { computed, reactive } from "vue"

const TOKEN_KEY = "clothing_store_token"
const USER_KEY = "clothing_store_user"

function readUser() {
  try {
    return JSON.parse(localStorage.getItem(USER_KEY) || "null")
  } catch {
    return null
  }
}

const state = reactive({
  token: localStorage.getItem(TOKEN_KEY),
  user: readUser(),
})

export const currentUser = computed(() => state.user)
export const isAuthenticated = computed(() => Boolean(state.token))
export const isAdmin = computed(() => state.user?.role === "admin")

export function getToken() {
  return state.token
}

export function setSession({ token, user }) {
  state.token = token
  state.user = user
  localStorage.setItem(TOKEN_KEY, token)
  localStorage.setItem(USER_KEY, JSON.stringify(user))
}

export function setUser(user) {
  state.user = user
  localStorage.setItem(USER_KEY, JSON.stringify(user))
}

export function clearSession() {
  state.token = null
  state.user = null
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(USER_KEY)
}
