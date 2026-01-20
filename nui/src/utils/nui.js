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

// Differentiated throttling by event type
const THROTTLE_CONFIG = {
  // Cameras and rotation - very strict
  'Client:Appearance:SetCameraView': { delay: 200, threshold: 5 },
  'Client:Appearance:RotatePed': { delay: 150, threshold: 8 },
  
  // Clothing and props - moderate
  'Client:Appearance:UpdateComponent': { delay: 50, threshold: 20 },
  'Client:Appearance:UpdateProp': { delay: 50, threshold: 20 },
  'Client:Appearance:UpdateFeature': { delay: 50, threshold: 20 },
  'Client:Appearance:UpdateOverlay': { delay: 50, threshold: 20 },
  // Removed UpdateHeadBlend - sliders need immediate response without throttling
  
  // Default for other events
  default: { delay: 100, threshold: 10 }
}

const SPAM_WINDOW = 1000   // 1 second spam detection window

/**
 * Check if a callback is being spammed
 */
function checkSpam(eventName, threshold) {
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
  if (throttleState.callCounts[eventName].length > threshold) {
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
  // TEMPORARILY DISABLED FOR DEBUGGING
  return false
  
  // Explicitly exclude these from throttling for smooth slider/immediate updates
  // if (eventName === 'Client:Appearance:UpdateHeadBlend' || 
  //     eventName === 'Client:Appearance:UpdateHeadOverlay') {
  //   return false // Never throttle these events
  // }
  // 
  // const now = Date.now()
  // const lastCall = throttleState.lastCallTimes[eventName] || 0
  // const config = THROTTLE_CONFIG[eventName] || THROTTLE_CONFIG.default
  // 
  // // Check for spam
  // if (checkSpam(eventName, config.threshold)) {
  //   return true // Block this call
  // }
  // 
  // // Check throttle delay
  // if (now - lastCall < config.delay) {
  //   return true // Too soon, block
  // }
  // 
  // // Update last call time
  // throttleState.lastCallTimes[eventName] = now
  // return false // Allow call
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
    console.error(`[NUI] Failed to send NUI message: ${callback}`, error)
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

// Guard to prevent duplicate handler registration
let handlersSetup = false

/**
 * Setup NUI message handlers
 */
export function setupNuiHandlers() {
  // Prevent duplicate handler registration (can happen during HMR or remounts)
  if (handlersSetup) {
    console.warn('[nui.js] setupNuiHandlers already called, skipping duplicate registration')
    return
  }
  
  handlersSetup = true
  console.log('[nui.js] Setting up NUI handlers (first time)')
  
  const uiStore = useUIStore()
  const notificationStore = useNotificationStore()
  const characterStore = useCharacterStore()
  const chatStore = useChatStore()
  
  // Import appearance and banking stores dynamically to avoid circular dependencies
  let appearanceStore = null
  let bankingStore = null
  let jobStore = null
  let phoneStore = null
  
  // Simple message handler
  const handleMessage = (event) => {
    const payload = event.data || event.detail
    
    if (!payload || !payload.message) {
      return
    }
    
    const { message, data } = payload
    
    try {
      switch (message) {
      // Connection status
      case 'connected':
        // Server connection established, NUI is ready
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
        // Transform character data from server format to NUI format
        const transformedCharacters = (data.characters || [])
          .filter(char => char != null)  // Filter out null/undefined entries
          .map(char => {
            const transformed = {
              id: char.Character_ID || char.id,
              name: `${char.First_Name || char.firstName || ''} ${char.Last_Name || char.lastName || ''}`.trim(),
              firstName: char.First_Name || char.firstName,
              lastName: char.Last_Name || char.lastName,
              cityId: char.City_ID || char.cityId,
              phone: char.Phone || char.phone,
              created: char.Created || char.created,
              lastSeen: char.Last_Seen || char.lastSeen,
              photo: char.Photo || char.photo,
              // Include all original data for reference
              ...char
            }
            return transformed
          })
        characterStore.setCharacters(transformedCharacters, data.slots || 1)
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

      case 'Client:NUI:HUDFocus':
        console.log(`[nui.js @ ${Date.now()}] HUDFocus received, focused=${data.focused}`)
        uiStore.setHudFocus(data.focused)
        console.log(`[nui.js @ ${Date.now()}] Sending NUI callback to Lua with focused=${data.focused}`)
        sendNuiMessage('NUI:Client:HUDSetFocus', { focused: data.focused })
        break

      case 'Client:NUI:HUDResetPosition':
        // HUD component handles position reset directly
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
      
      // Job management system
      case 'Client:NUI:JobOpen':
        if (!jobStore) {
          import('../stores/job.js').then(module => {
            jobStore = module.useJobStore()
            jobStore.open(data)
          })
        } else {
          jobStore.open(data)
        }
        break
      
      case 'Client:NUI:JobClose':
        if (jobStore) {
          jobStore.close()
        }
        break
      
      case 'Client:NUI:JobUpdateAccounts':
        if (jobStore) {
          jobStore.updateAccounts(data.accounts)
        }
        break
      
      case 'Client:NUI:JobUpdateMemos':
        if (jobStore) {
          jobStore.updateMemos(data.memos)
        }
        break
      
      case 'Client:NUI:JobUpdateEmployees':
        if (jobStore) {
          jobStore.updateEmployees(data.employees)
        }
        break
      
      case 'Client:NUI:JobUpdatePrices':
        if (jobStore) {
          jobStore.updatePrices(data.prices)
        }
        break
      
      case 'Client:NUI:JobUpdateLocations':
        if (jobStore) {
          jobStore.updateLocations(data.locations)
        }
        break
      
      case 'Client:NUI:JobUpdateFinancials':
        if (jobStore) {
          jobStore.updateFinancials(data.financials)
        }
        break
      
      // Phone system
      case 'Client:NUI:PhoneOpen':
        if (!phoneStore) {
          import('../stores/phone.js').then(module => {
            phoneStore = module.usePhoneStore()
            phoneStore.open(data)
          })
        } else {
          phoneStore.open(data)
        }
        break
      
      case 'Client:NUI:PhoneClose':
        if (phoneStore) {
          phoneStore.close()
        }
        break
      
      case 'Client:NUI:PhoneSettingsUpdated':
        if (phoneStore) {
          phoneStore.updateSettings(data)
        }
        break
      
      case 'Client:NUI:PhoneContactsUpdated':
        if (phoneStore) {
          phoneStore.updateContacts(data)
        }
        break
      
      case 'Client:NUI:PhoneCallHistoryUpdated':
        if (phoneStore) {
          phoneStore.updateCallHistory(data)
        }
        break
      
      case 'Client:NUI:PhoneCallIncoming':
        if (phoneStore) {
          phoneStore.receiveCall(data)
        }
        break
      
      case 'Client:NUI:PhoneCallOutgoing':
        if (phoneStore) {
          phoneStore.initiateCall(data.targetNumber)
        }
        break
      
      case 'Client:NUI:PhoneCallEnded':
        if (phoneStore) {
          phoneStore.endCall()
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
      } else if (phoneStore && phoneStore.isVisible) {
        phoneStore.close()
        sendNuiMessage('NUI:Client:PhoneClose')
      } else if (jobStore && jobStore.isVisible) {
        jobStore.close()
        sendNuiMessage('NUI:Client:JobClose')
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
