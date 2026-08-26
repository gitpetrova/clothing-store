<script setup>
import { onMounted, ref } from "vue"
import { fetchProfile } from "@/api/auth"
import { currentUser } from "@/auth/session"

const error = ref("")
const loading = ref(true)

onMounted(async () => {
  try {
    await fetchProfile()
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <section class="panel">
    <h2>Account</h2>
    <p class="muted">Loaded from <code>GET /api/v1/profile</code> with the JWT interceptor.</p>

    <p v-if="error" class="banner">{{ error }}</p>
    <p v-else-if="loading" class="muted">Loading profile…</p>
    <dl v-else-if="currentUser" class="facts">
      <div>
        <dt>Name</dt>
        <dd>{{ currentUser.name }}</dd>
      </div>
      <div>
        <dt>Email</dt>
        <dd>{{ currentUser.email }}</dd>
      </div>
      <div>
        <dt>Role</dt>
        <dd>{{ currentUser.role }}</dd>
      </div>
    </dl>
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

.muted {
  color: var(--muted);
  font-size: 0.92rem;
}

.banner {
  background: #fff1f2;
  color: #9f1239;
  padding: 10px 12px;
  border-radius: 10px;
}

code {
  font-size: 0.86em;
  background: var(--accent-soft);
  padding: 0.05em 0.35em;
  border-radius: 6px;
}

.facts {
  display: grid;
  gap: 12px;
  margin: 0;
}

.facts > div {
  display: grid;
  gap: 2px;
  padding: 12px;
  border: 1px solid var(--line);
  border-radius: 12px;
}

dt {
  color: var(--muted);
  font-size: 0.78rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

dd {
  margin: 0;
  font-weight: 600;
}
</style>
