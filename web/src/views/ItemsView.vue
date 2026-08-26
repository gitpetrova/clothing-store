<script setup>
import { onMounted, ref } from "vue"
import { createItem, deleteItem, listItems, updateItem } from "@/api/items"

const items = ref([])
const loading = ref(true)
const error = ref("")
const title = ref("")
const description = ref("")
const saving = ref(false)
const editingId = ref(null)
const draft = ref({ title: "", description: "" })

async function refresh() {
  loading.value = true
  error.value = ""
  try {
    items.value = await listItems()
  } catch (err) {
    error.value = err.message + ". Is the Rails API running on port 3000?"
  } finally {
    loading.value = false
  }
}

async function onCreate() {
  if (!title.value.trim()) return
  saving.value = true
  error.value = ""
  try {
    const item = await createItem({
      title: title.value.trim(),
      description: description.value.trim(),
      completed: false,
    })
    items.value.unshift(item)
    title.value = ""
    description.value = ""
  } catch (err) {
    error.value = err.message
  } finally {
    saving.value = false
  }
}

async function toggle(item) {
  const next = { ...item, completed: !item.completed }
  try {
    const updated = await updateItem(item.id, { completed: next.completed })
    items.value = items.value.map((row) => (row.id === item.id ? updated : row))
  } catch (err) {
    error.value = err.message
  }
}

function startEdit(item) {
  editingId.value = item.id
  draft.value = { title: item.title, description: item.description || "" }
}

function cancelEdit() {
  editingId.value = null
}

async function saveEdit(item) {
  try {
    const updated = await updateItem(item.id, {
      title: draft.value.title.trim(),
      description: draft.value.description.trim(),
    })
    items.value = items.value.map((row) => (row.id === item.id ? updated : row))
    editingId.value = null
  } catch (err) {
    error.value = err.message
  }
}

async function remove(item) {
  if (!window.confirm(`Delete “${item.title}”?`)) return
  try {
    await deleteItem(item.id)
    items.value = items.value.filter((row) => row.id !== item.id)
  } catch (err) {
    error.value = err.message
  }
}

onMounted(refresh)
</script>

<template>
  <section class="panel">
    <form class="composer" @submit.prevent="onCreate">
      <input v-model="title" placeholder="Add an item…" maxlength="120" />
      <textarea v-model="description" rows="2" placeholder="Optional description" />
      <button type="submit" :disabled="saving || !title.trim()">
        {{ saving ? "Saving…" : "Create" }}
      </button>
    </form>

    <p v-if="error" class="banner">{{ error }}</p>
    <p v-else-if="loading" class="muted">Loading items…</p>
    <p v-else-if="!items.length" class="muted">No items yet. Create one above.</p>

    <ul v-else class="list">
      <li v-for="item in items" :key="item.id" :class="{ done: item.completed }">
        <button class="check" type="button" :aria-pressed="item.completed" @click="toggle(item)">
          {{ item.completed ? "✓" : "" }}
        </button>

        <div v-if="editingId === item.id" class="edit">
          <input v-model="draft.title" />
          <textarea v-model="draft.description" rows="2" />
          <div class="row">
            <button type="button" class="primary" @click="saveEdit(item)">Save</button>
            <button type="button" class="ghost" @click="cancelEdit">Cancel</button>
          </div>
        </div>

        <div v-else class="body">
          <h2>{{ item.title }}</h2>
          <p v-if="item.description">{{ item.description }}</p>
        </div>

        <div v-if="editingId !== item.id" class="actions">
          <button type="button" class="ghost" @click="startEdit(item)">Edit</button>
          <button type="button" class="ghost danger" @click="remove(item)">Delete</button>
        </div>
      </li>
    </ul>
  </section>
</template>

<style scoped>
.panel {
  background: var(--paper);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  padding: 22px;
}

.composer {
  display: grid;
  gap: 10px;
  margin-bottom: 22px;
}

input,
textarea {
  width: 100%;
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 10px 12px;
  background: #fff;
  color: var(--ink);
}

button.primary,
.composer button {
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
  margin-bottom: 16px;
}

.muted {
  color: var(--muted);
}

.list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 12px;
}

li {
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: 12px;
  align-items: start;
  padding: 12px;
  border: 1px solid var(--line);
  border-radius: 12px;
}

.check {
  width: 28px;
  height: 28px;
  border-radius: 8px;
  border: 1.5px solid var(--ink);
  background: transparent;
  display: grid;
  place-items: center;
  font-weight: 700;
}

.done .check {
  background: var(--done);
  border-color: var(--done);
  color: #fff;
}

.done h2,
.done .body p {
  text-decoration: line-through;
  color: var(--muted);
}

h2 {
  font-size: 1.05rem;
  font-weight: 650;
}

.body p {
  color: var(--muted);
  font-size: 0.92rem;
}

.actions,
.row {
  display: flex;
  gap: 6px;
}

.ghost {
  background: transparent;
  border: 0;
  color: var(--muted);
  padding: 4px 6px;
}

.danger:hover {
  color: #be123c;
}

.edit {
  display: grid;
  gap: 8px;
}
</style>
