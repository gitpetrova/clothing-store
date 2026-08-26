<script setup>
import { RouterLink, RouterView, useRouter } from "vue-router"
import { logout } from "@/api/auth"
import { currentUser, isAuthenticated } from "@/auth/session"
import { cartCount } from "@/cart/store"

const router = useRouter()

function onLogout() {
  logout()
  router.push({ name: "login" })
}
</script>

<template>
  <div class="shell">
    <header class="top">
      <div>
        <p class="eyebrow">Clothing store · Vue 3</p>
        <h1>The rack</h1>
      </div>
      <nav class="nav">
        <RouterLink to="/">Products</RouterLink>
        <RouterLink v-if="isAuthenticated" to="/cart">Cart ({{ cartCount }})</RouterLink>
        <template v-if="isAuthenticated">
          <RouterLink to="/account">{{ currentUser?.name || "Account" }}</RouterLink>
          <button type="button" class="ghost" @click="onLogout">Log out</button>
        </template>
        <template v-else>
          <RouterLink to="/login">Sign in</RouterLink>
          <RouterLink to="/register">Register</RouterLink>
        </template>
      </nav>
    </header>
    <RouterView />
  </div>
</template>

<style scoped>
.shell {
  max-width: 1080px;
  margin: 0 auto;
  padding: 48px 20px 80px;
}

.top {
  display: flex;
  justify-content: space-between;
  gap: 24px;
  align-items: end;
  margin-bottom: 36px;
}

.eyebrow {
  text-transform: uppercase;
  letter-spacing: 0.14em;
  font-size: 0.72rem;
  color: var(--accent);
  font-weight: 600;
}

h1 {
  font-family: "Fraunces", Georgia, serif;
  font-size: 2.4rem;
  font-weight: 560;
  letter-spacing: -0.03em;
}

.nav {
  display: flex;
  gap: 14px;
  align-items: center;
  flex-wrap: wrap;
}

.nav a {
  color: var(--muted);
  text-decoration: none;
  font-size: 0.92rem;
  font-weight: 600;
}

.nav a.router-link-active {
  color: var(--ink);
}

.ghost {
  background: transparent;
  border: 0;
  color: var(--muted);
  padding: 0;
  font-weight: 600;
  font-size: 0.92rem;
}

@media (max-width: 640px) {
  .top {
    flex-direction: column;
    align-items: start;
  }
}
</style>
