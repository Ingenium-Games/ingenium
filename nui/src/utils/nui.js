import { useUIStore } from '../stores/ui'
import { useNotificationStore } from '../stores/notifications'
import { useCharacterStore } from '../stores/character'
import { useChatStore } from '../stores/chat'

/**
 * Throttle state management for preventing spam
 */
const throttleState = {
  lastCallTimes: {},
  callCounts: {},
  spamWarningShown: false,
  warningTimeout: null
}

const THROTTLE_DELAY = 100 // Minimum ms between calls
const SPAM_THRESHOLD = 10  // Max calls within spam window
const SPAM_WINDOW = 1000   // 1 second spam detection window

/**
 * Check if a callback is being spammed
 */
function checkSpam(eventName) {
  const now = Date.now()
  
  // Initialize tracking for this event
  if (!throttleState.callCounts[eventName]) {
    throttleState.callCounts[eventName] = []
  }
  
  // Clean old timestamps outside spam window
  throttleState.callCounts[eventName] = throttleState.callCounts[eventName].filter(
    timestamp => (now - timestamp) < SPAM_WINDOW
  )
  
  // Add current call
  throttleState.callCounts[eventName].push(now)
  
  // Check if spamming
  if (throttleState.callCounts[eventName].length > SPAM_THRESHOLD) {
    if (!throttleState.spamWarningShown) {
      console.warn(`[NUI] Please slow down - too many rapid requests for ${eventName}`)
      throttleState.spamWarningShown = true
      
      // Reset warning flag after 5 seconds
      if (throttleState.warningTimeout) {
        clearTimeout(throttleState.warningTimeout)
      }
      throttleState.warningTimeout = setTimeout(() => {
        throttleState.spamWarningShown = false
      }, 5000)
    }
    return true
  }
  
  return false
}

/**
 * Check if callback should be throttled
 */
function shouldThrottle(eventName) {
  const now = Date.now()
  const lastCall = throttleState.lastCallTimes[eventName] || 0
  
  // Check for spam
  if (checkSpam(eventName)) {
    return true // Block this call
  }
  
  // Check throttle delay
  if (now - lastCall < THROTTLE_DELAY) {
    return true // Too soon, block
  }
  
  // Update last call time
  throttleState.lastCallTimes[eventName] = now
  return false // Allow call
}

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
  // Check throttle
  if (shouldThrottle(callback)) {
    console.debug(`[NUI] Throttled: ${callback}`)
    return { ok: false, error: 'Throttled' }
  }
  
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
  console.log('[setupNuiHandlers] Starting setup of NUI handlers')
  const uiStore = useUIStore()
  const notificationStore = useNotificationStore()
  const characterStore = useCharacterStore()
  const chatStore = useChatStore()
  
  // Import appearance and banking stores dynamically to avoid circular dependencies
  let appearanceStore = null
  let bankingStore = null
  
  console.log('[setupNuiHandlers] Attaching window message event listener')
  
  // Simple message handler
  const handleMessage = (event) => {
    const payload = event.data || event.detail
    
    if (!payload || !payload.message) {
      return
    }
    
    const { message, data } = payload
    
    console.log('[handleMessage] Processing message:', message)
    
    try {
      switch (message) {
      // Connection status
      case 'connected':
        // Server connection established, NUI is ready
        console.log('NUI connected to server')
        break

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
        console.log('[NUI] Character select show received with data:', data)
        characterStore.setCharacters(data.characters || [], data.slots || 1)
        console.log('[NUI] UI Store showCharacterSelect set to true')
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
        // uiStore.showCharacterSelect = false not needed to close as within nui event to open, the handled callback is sending this to the NUI upon reciving before its loop.

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
    } catch (error) {
      console.error('[handleMessage] Error in message handler:', error, error.stack)
    }
  }
  
  window.addEventListener('message', handleMessage)
  
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
