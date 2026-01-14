import { useUIStore } from '../stores/ui'
import { useNotificationStore } from '../stores/notifications'
import { useCharacterStore } from '../stores/character'
import { useChatStore } from '../stores/chat'

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
  const chatStore = useChatStore()
  
  // Import appearance and banking stores dynamically to avoid circular dependencies
  let appearanceStore = null
  let bankingStore = null
  
  window.addEventListener('message', (event) => {
    const { message, data } = event.data
    
    switch (message) {
      // Chat system
      case 'Client:NUI:ChatAddMessage':
        chatStore.addMessage(data)
        break

      case 'Client:NUI:ChatShow':
        chatStore.show()
        break

      case 'Client:NUI:ChatHide':
        chatStore.hide()
        break

      case 'Client:NUI:ChatClear':
        chatStore.clearMessages()
        break

      case 'Client:NUI:ChatSetSuggestions':
        chatStore.setSuggestions(data.suggestions || [])
        break

      // Notification system
      case 'Client:NUI:Notification':
        notificationStore.addNotification({
          text: data.text,
          color: data.colour || data.color || 'black',
          fade: data.fade || 13500
        })
        break

      // Character select
      case 'Client:NUI:CharacterSelectShow':
        characterStore.setCharacters(data.characters || [])
        uiStore.showCharacterSelect = true
        break

      case 'Client:NUI:CharacterSelectHide':
        uiStore.showCharacterSelect = false
        break

      // HUD
      case 'Client:NUI:HUDShow':
        uiStore.showHUD = true
        break

      case 'Client:NUI:HUDHide':
        uiStore.showHUD = false
        break

      case 'Client:NUI:HUDUpdate':
        uiStore.updateHUD(data)
        break

      // Menu system
      case 'Client:NUI:MenuShow':
        uiStore.openMenu(data)
        break

      case 'Client:NUI:MenuHide':
        uiStore.showMenu = false
        break

      // Input dialog
      case 'Client:NUI:InputShow':
        uiStore.openInput(data)
        break

      case 'Client:NUI:InputHide':
        uiStore.showInput = false
        break

      // Context menu
      case 'Client:NUI:ContextShow':
        uiStore.openContextMenu(data)
        break

      case 'Client:NUI:ContextHide':
        uiStore.showContextMenu = false
        break

      // Appearance customization
      case 'Client:NUI:AppearanceOpen':
        if (!appearanceStore) {
          import('../stores/appearance.js').then(module => {
            appearanceStore = module.useAppearanceStore()
            appearanceStore.open(data)
          })
        } else {
          appearanceStore.open(data)
        }
        break

      case 'Client:NUI:AppearanceClose':
        if (appearanceStore) {
          appearanceStore.close()
        }
        break

      // Banking system
      case 'Client:NUI:BankingOpen':
        if (!bankingStore) {
          import('../stores/banking.js').then(module => {
            bankingStore = module.useBankingStore()
            bankingStore.open(data)
          })
        } else {
          bankingStore.open(data)
        }
        break

      case 'Client:NUI:BankingClose':
        if (bankingStore) {
          bankingStore.close()
        }
        break

      case 'Client:NUI:BankingUpdateBalance':
        if (bankingStore) {
          bankingStore.updateBalance(data.balance)
        }
        break

      case 'Client:NUI:BankingUpdateCash':
        if (bankingStore) {
          bankingStore.updateCash(data.cash)
        }
        break

      case 'Client:NUI:BankingAddTransaction':
        if (bankingStore) {
          bankingStore.addTransaction(data)
        }
        break

      case 'Client:NUI:BankingUpdateFavorites':
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
      if (chatStore.isVisible) {
        chatStore.hide()
        sendNuiMessage('NUI:Client:ChatClose')
      } else if (bankingStore && bankingStore.isVisible) {
        bankingStore.close()
        sendNuiMessage('NUI:Client:BankingClose')
      } else if (uiStore.showMenu) {
        uiStore.showMenu = false
        sendNuiMessage('NUI:Client:MenuClose')
      } else if (uiStore.showInput) {
        uiStore.showInput = false
        sendNuiMessage('NUI:Client:InputClose')
      } else if (uiStore.showContextMenu) {
        uiStore.showContextMenu = false
        sendNuiMessage('NUI:Client:ContextClose')
      } else if (!characterStore.isInCharacterSelect) {
        // Only send generic close if not in character select
        sendNuiMessage('NUI:Client:Close')
      }
    }
  })
}

/**
 * Map legacy callback names to directional NUI:Client names.
 * If no mapping exists, return the original callback.
 */
// Note: frontend now must call directional NUI endpoints directly (NUI:Client:...)
