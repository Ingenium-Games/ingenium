import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

// Wait for DOM to be ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    const appElement = document.getElementById('inventory-app')
    if (appElement) {
      createApp(App).mount('#inventory-app')
    }
  })
} else {
  const appElement = document.getElementById('inventory-app')
  if (appElement) {
    createApp(App).mount('#inventory-app')
  }
}

