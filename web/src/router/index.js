import { createRouter, createWebHistory } from "vue-router"
import { isAuthenticated } from "@/auth/session"
import ProductsView from "@/views/ProductsView.vue"
import ProductShowView from "@/views/ProductShowView.vue"
import ItemsView from "@/views/ItemsView.vue"
import LoginView from "@/views/LoginView.vue"
import RegisterView from "@/views/RegisterView.vue"
import AccountView from "@/views/AccountView.vue"
import CartView from "@/views/CartView.vue"

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: "/", name: "products", component: ProductsView, meta: { requiresAuth: true } },
    { path: "/products/:id", name: "product", component: ProductShowView, meta: { requiresAuth: true } },
    { path: "/items", name: "items", component: ItemsView },
    { path: "/login", name: "login", component: LoginView, meta: { guest: true } },
    { path: "/register", name: "register", component: RegisterView, meta: { guest: true } },
    { path: "/account", name: "account", component: AccountView, meta: { requiresAuth: true } },
    { path: "/cart", name: "cart", component: CartView, meta: { requiresAuth: true } },
  ],
})

router.beforeEach((to) => {
  if (to.meta.requiresAuth && !isAuthenticated.value) {
    return { name: "login", query: { redirect: to.fullPath } }
  }

  if (to.meta.guest && isAuthenticated.value) {
    return { name: "products" }
  }

  return true
})

export default router
