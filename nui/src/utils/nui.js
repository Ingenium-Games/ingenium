import { useUIStore } from '../stores/ui'
import { useNotificationStore } from '../stores/notifications'
import { useCharacterStore } from '../stores/character'

/**
 * Send a message back to the client Lua script
 */
export function sendNuiMessage(callback, data = {}) {
  fetch(`https://${GetParentResourceName()}/${callback}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
  })
}

/**
 * Get the parent resource name (for NUI callbacks)
 */
function GetParentResourceName() {
  // In development, return a dummy name
  if (import.meta.env.DEV) {
    return 'ig.core'
  }
  
  let intervalId
  let result = null
  
  const checkForResourceName = () => {
    if (window.GetParentResourceName) {
      result = window.GetParentResourceName()
      clearInterval(intervalId)
    }
  }
  
  intervalId = setInterval(checkForResourceName, 100)
  
  return result || 'ig.core'
}

/**
 * Setup NUI message handlers
 */
export function setupNuiHandlers() {
  const uiStore = useUIStore()
  const notificationStore = useNotificationStore()
  const characterStore = useCharacterStore()
  
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
      
      default:
        console.log('Unhandled NUI message:', message, data)
        break
    }
  })
  
  // ESC key handler
  window.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      // Close active UI elements
      if (uiStore.showMenu) {
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
