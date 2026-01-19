import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const usePhoneStore = defineStore('phone', () => {
  // Phone visibility and state
  const isVisible = ref(false)
  const isUnlocked = ref(false)
  const currentApp = ref('home') // 'home', 'settings', 'contacts', etc.
  
  // Phone data
  const phoneData = ref({
    imei: null,
    phoneNumber: null,
    contacts: [],
    settings: {
      planeMode: false,
      emergencyAlerts: true,
      provider: 'Warstock'
    }
  })
  
  // UI state
  const animationState = ref('closed') // 'closed', 'opening', 'open', 'closing'
  
  // Computed
  const isPlaneMode = computed(() => phoneData.value.settings.planeMode)
  const hasEmergencyAlerts = computed(() => phoneData.value.settings.emergencyAlerts)
  
  // Actions
  function open(data) {
    phoneData.value = {
      imei: data.imei,
      phoneNumber: data.phoneNumber,
      contacts: data.contacts || [],
      settings: data.settings || {
        planeMode: false,
        emergencyAlerts: true,
        provider: 'Warstock'
      }
    }
    
    animationState.value = 'opening'
    isVisible.value = true
    isUnlocked.value = false
    currentApp.value = 'home'
    
    // Set animation state to open after animation completes
    setTimeout(() => {
      if (isVisible.value) {
        animationState.value = 'open'
      }
    }, 600) // Match CSS animation duration
  }
  
  function close() {
    animationState.value = 'closing'
    
    // Wait for closing animation before hiding
    setTimeout(() => {
      isVisible.value = false
      isUnlocked.value = false
      currentApp.value = 'home'
      animationState.value = 'closed'
      
      // Reset phone data
      phoneData.value = {
        imei: null,
        phoneNumber: null,
        contacts: [],
        settings: {
          planeMode: false,
          emergencyAlerts: true,
          provider: 'Warstock'
        }
      }
    }, 400) // Match CSS animation duration
  }
  
  function unlock() {
    isUnlocked.value = true
  }
  
  function openApp(appName) {
    currentApp.value = appName
  }
  
  function goHome() {
    currentApp.value = 'home'
  }
  
  function updateSettings(settings) {
    phoneData.value.settings = { ...phoneData.value.settings, ...settings }
  }
  
  function updateContacts(contacts) {
    phoneData.value.contacts = contacts
  }
  
  function addContact(contact) {
    phoneData.value.contacts.push(contact)
  }
  
  function removeContact(contactId) {
    phoneData.value.contacts = phoneData.value.contacts.filter(c => c.id !== contactId)
  }
  
  function updateContact(contactId, updatedContact) {
    const index = phoneData.value.contacts.findIndex(c => c.id === contactId)
    if (index !== -1) {
      phoneData.value.contacts[index] = { ...phoneData.value.contacts[index], ...updatedContact }
    }
  }
  
  return {
    // State
    isVisible,
    isUnlocked,
    currentApp,
    phoneData,
    animationState,
    
    // Computed
    isPlaneMode,
    hasEmergencyAlerts,
    
    // Actions
    open,
    close,
    unlock,
    openApp,
    goHome,
    updateSettings,
    updateContacts,
    addContact,
    removeContact,
    updateContact
  }
})
