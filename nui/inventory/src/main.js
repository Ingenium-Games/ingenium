import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

// Function to mount the Vue app
function mountInventoryApp() {
  const appElement = document.getElementById('inventory-app')
  if (appElement) {
    createApp(App).mount('#inventory-app')
  }
}

// Wait for DOM to be ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', mountInventoryApp)
} else {
  mountInventoryApp()
}

