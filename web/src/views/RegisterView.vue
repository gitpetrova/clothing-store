<script setup>
import { ref } from "vue"
import { RouterLink, useRouter } from "vue-router"
import { register } from "@/api/auth"

const router = useRouter()
const name = ref("")
const email = ref("")
const password = ref("")
const passwordConfirmation = ref("")
const error = ref("")
const saving = ref(false)

async function onSubmit() {
  saving.value = true
  error.value = ""
  try {
    await register({
      name: name.value.trim(),
      email: email.value.trim(),
      password: password.value,
      password_confirmation: passwordConfirmation.value,
    })
    router.push({ name: "products" })
  } catch (err) {
    error.value = err.message
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <section class="panel">
    <h2>Create an account</h2>
    <p class="muted">New shoppers get the <code>user</code> role. Admins are created on the API.</p>

    <form class="form" @submit.prevent="onSubmit">
      <label>
        Name
        <input v-model="name" autocomplete="name" required />
      </label>
      <label>
        Email
        <input v-model="email" type="email" autocomplete="email" required />
      </label>
      <label>
        Password
        <input v-model="password" type="password" autocomplete="new-password" minlength="8" required />
      </label>
      <label>
        Confirm password
        <input v-model="passwordConfirmation" type="password" autocomplete="new-password" minlength="8" required />
      </label>
      <p v-if="error" class="banner">{{ error }}</p>
      <button type="submit" :disabled="saving">{{ saving ? "Creating…" : "Register" }}</button>
    </form>

    <p class="muted">
      Already have an account?
      <RouterLink to="/login">Sign in</RouterLink>
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
