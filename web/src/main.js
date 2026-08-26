import { createApp } from "vue"
import App from "./App.vue"
import { restoreSession } from "@/api/auth"
import router from "./router"
import "./assets/main.css"

const app = createApp(App)

restoreSession().finally(() => {
  app.use(router)
  app.mount("#app")
})
