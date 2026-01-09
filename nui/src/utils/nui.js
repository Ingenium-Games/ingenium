import { useUIStore } from '../stores/ui'
import { useNotificationStore } from '../stores/notifications'
import { useCharacterStore } from '../stores/character'

/**
 * Send a message back to the client Lua script
 */
export async function sendNuiMessage(callback, data = {}) {
  try {
    const resourceName = await GetParentResourceName()
    const response = await fetch(`https://${resourceName}/${callback}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    })
    return response
  } catch (error) {
    if (!import.meta.env.DEV) {
      console.error('Failed to send NUI message:', error)
    }
  }
}

/**
 * Call a client callback and wait for response
 */
export async function callClientCallback(callback, ...args) {
  try {
    const resourceName = await GetParentResourceName()
    const response = await fetch(`https://${resourceName}/${callback}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(args)
    })
    
    if (response.ok) {
      return await response.json()
    }
    return null
  } catch (error) {
    if (!import.meta.env.DEV) {
      console.error('Failed to call client callback:', error)
    }
    return null
  }
}

/**
 * Get the parent resource name (for NUI callbacks)
 */
function GetParentResourceName() {
  // In development, return a dummy name
  if (import.meta.env.DEV) {
    return Promise.resolve('ingenium')
  }
  
  return new Promise((resolve) => {
    if (window.GetParentResourceName) {
      resolve(window.GetParentResourceName())
    } else {
      // Wait for the function to be available
      const checkInterval = setInterval(() => {
        if (window.GetParentResourceName) {
          clearInterval(checkInterval)
          resolve(window.GetParentResourceName())
        }
      }, 100)
      
      // Timeout after 5 seconds
      setTimeout(() => {
        clearInterval(checkInterval)
        resolve('ingenium') // Fallback
      }, 5000)
    }
  })
}

/**
 * Setup NUI message handlers
 */
export function setupNuiHandlers() {
  const uiStore = useUIStore()
  const notificationStore = useNotificationStore()
  const characterStore = useCharacterStore()
  
  // Import appearance and banking stores dynamically to avoid circular dependencies
  let appearanceStore = null
  let bankingStore = null
  
  window.addEventListener('message', (event) => {
    const { message, data } = event.data
    
    switch (message) {
      // Notification system (backwards compatible)
      case 'notification':
        notificationStore.addNotification({
          text: data.text,
          color: data.colour || data.color || 'black',
          fade: data.fade || 13500
        })
        break
      
      // Character select
      case 'character-select:show':
        characterStore.setCharacters(data.characters || [])
        uiStore.showCharacterSelect = true
        break
      
      case 'character-select:hide':
        uiStore.showCharacterSelect = false
        break
      
      // HUD
      case 'hud:show':
        uiStore.showHUD = true
        break
      
      case 'hud:hide':
        uiStore.showHUD = false
        break
      
      case 'hud:update':
        uiStore.updateHUD(data)
        break
      
      // Menu system
      case 'menu:show':
        uiStore.openMenu(data)
        break
      
      case 'menu:hide':
        uiStore.showMenu = false
        break
      
      // Input dialog
      case 'input:show':
        uiStore.openInput(data)
        break
      
      case 'input:hide':
        uiStore.showInput = false
        break
      
      // Context menu
      case 'context:show':
        uiStore.openContextMenu(data)
        break
      
      case 'context:hide':
        uiStore.showContextMenu = false
        break
      
      // Appearance customization
      case 'appearance:open':
        if (!appearanceStore) {
          // Lazy load appearance store
          import('../stores/appearance.js').then(module => {
            appearanceStore = module.useAppearanceStore()
            appearanceStore.open(data)
          })
        } else {
          appearanceStore.open(data)
        }
        break
      
      case 'appearance:close':
        if (appearanceStore) {
          appearanceStore.close()
        }
        break
      
      // Banking system
      case 'banking:open':
        if (!bankingStore) {
          // Lazy load banking store
          import('../stores/banking.js').then(module => {
            bankingStore = module.useBankingStore()
            bankingStore.open(data)
          })
        } else {
          bankingStore.open(data)
        }
        break
      
      case 'banking:close':
        if (bankingStore) {
          bankingStore.close()
        }
        break
      
      case 'banking:updateBalance':
        if (bankingStore) {
          bankingStore.updateBalance(data.balance)
        }
        break
      
      case 'banking:updateCash':
        if (bankingStore) {
          bankingStore.updateCash(data.cash)
        }
        break
      
      case 'banking:addTransaction':
        if (bankingStore) {
          bankingStore.addTransaction(data)
        }
        break
      
      case 'banking:updateFavorites':
        if (bankingStore && data.favorites) {
          bankingStore.favorites = data.favorites
        }
        break
      
      default:
        console.log('Unhandled NUI message:', message, data)
        break
    }
  })
  
  // ESC key handler
  window.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      // Close active UI elements
      if (bankingStore && bankingStore.isVisible) {
        bankingStore.close()
        sendNuiMessage('banking:close')
      } else if (uiStore.showMenu) {
        uiStore.showMenu = false
        sendNuiMessage('menu:close')
      } else if (uiStore.showInput) {
        uiStore.showInput = false
        sendNuiMessage('input:close')
      } else if (uiStore.showContextMenu) {
        uiStore.showContextMenu = false
        sendNuiMessage('context:close')
      } else if (!characterStore.isInCharacterSelect) {
        // Only send generic close if not in character select
        sendNuiMessage('_c__close')
      }
    }
  })
}
