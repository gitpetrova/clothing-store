<script setup>
import { ref } from "vue"
import { RouterLink, useRoute, useRouter } from "vue-router"
import { login } from "@/api/auth"

const router = useRouter()
const route = useRoute()
const email = ref("user@example.com")
const password = ref("password123")
const error = ref("")
const saving = ref(false)

async function onSubmit() {
  saving.value = true
  error.value = ""
  try {
    await login(email.value.trim(), password.value)
    router.push(route.query.redirect || { name: "products" })
  } catch (err) {
    error.value = err.message
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <section class="panel">
    <h2>Sign in</h2>
    <p class="muted">Use a store account. Seeded shopper is <code>user@example.com</code> / <code>password123</code>.</p>

    <form class="form" @submit.prevent="onSubmit">
      <label>
        Email
        <input v-model="email" type="email" autocomplete="email" required />
      </label>
      <label>
        Password
        <input v-model="password" type="password" autocomplete="current-password" required />
      </label>
      <p v-if="error" class="banner">{{ error }}</p>
      <button type="submit" :disabled="saving">{{ saving ? "Signing in…" : "Sign in" }}</button>
    </form>

    <p class="muted">
      New here?
      <RouterLink to="/register">Create an account</RouterLink>
    </p>
  </section>
</template>

<style scoped>
.panel {
  background: var(--paper);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  padding: 22px;
  display: grid;
  gap: 14px;
}

.form {
  display: grid;
  gap: 12px;
}

label {
  display: grid;
  gap: 6px;
  font-size: 0.92rem;
  font-weight: 600;
}

input {
  width: 100%;
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 10px 12px;
  background: #fff;
  color: var(--ink);
  font-weight: 400;
}

button {
  justify-self: start;
  background: var(--ink);
  color: #fff;
  border: 0;
  border-radius: 999px;
  padding: 8px 16px;
  font-weight: 600;
}

button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.banner {
  background: #fff1f2;
  color: #9f1239;
  padding: 10px 12px;
  border-radius: 10px;
}

.muted {
  color: var(--muted);
  font-size: 0.92rem;
}

code {
  font-size: 0.86em;
  background: var(--accent-soft);
  padding: 0.05em 0.35em;
  border-radius: 6px;
}

a {
  color: var(--accent);
}
</style>
