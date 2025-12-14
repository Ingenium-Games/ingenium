import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

// Store app instance for potential cleanup
let appInstance = null

// Function to mount the Vue app
function mountInventoryApp() {
  const appElement = document.getElementById('inventory-app')
  if (appElement && !appInstance) {
    appInstance = createApp(App)
    appInstance.mount('#inventory-app')
  }
}

// Wait for DOM to be ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', mountInventoryApp)
} else {
  mountInventoryApp()
}

