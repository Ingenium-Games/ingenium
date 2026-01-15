import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import './style.css'

// Test logging to confirm script is running
console.log('[main.js] NUI Script loaded')

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.mount('#app')
