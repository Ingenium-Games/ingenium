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
    callHistory: [],
    settings: {
      planeMode: false,
      emergencyAlerts: true,
      provider: 'Warstock'
    }
  })
  
  // Active call state
  const activeCall = ref(null) // { id, number, status: 'incoming'|'outgoing'|'active', duration, startTime }
  
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
      callHistory: data.callHistory || [],
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
        callHistory: [],
        settings: {
          planeMode: false,
          emergencyAlerts: true,
          provider: 'Warstock'
        }
      }
      
      // Reset active call
      activeCall.value = null
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
  
  // Call History Management
  function updateCallHistory(history) {
    phoneData.value.callHistory = history
  }
  
  function addCallHistory(call) {
    phoneData.value.callHistory.unshift(call) // Add to beginning
  }
  
  function deleteCallHistory(callId) {
    phoneData.value.callHistory = phoneData.value.callHistory.filter(c => c.id !== callId)
  }
  
  // Call Management
  function initiateCall(number) {
    activeCall.value = {
      id: Date.now().toString(),
      number: number,
      status: 'outgoing',
      duration: 0,
      startTime: Date.now()
    }
  }
  
  function receiveCall(callData) {
    activeCall.value = {
      id: callData.id,
      number: callData.number,
      status: 'incoming',
      duration: 0,
      startTime: null
    }
  }
  
  function answerCall() {
    if (activeCall.value) {
      activeCall.value.status = 'active'
      activeCall.value.startTime = Date.now()
    }
  }
  
  function endCall() {
    if (activeCall.value) {
      // Calculate final duration if call was active
      if (activeCall.value.startTime) {
        const duration = Math.floor((Date.now() - activeCall.value.startTime) / 1000)
        activeCall.value.duration = duration
        
        // Add to call history
        addCallHistory({
          id: activeCall.value.id,
          number: activeCall.value.number,
          type: activeCall.value.status === 'outgoing' ? 'outgoing' : 'incoming',
          duration: duration,
          timestamp: activeCall.value.startTime
        })
      } else {
        // Missed or declined call
        addCallHistory({
          id: activeCall.value.id,
          number: activeCall.value.number,
          type: 'missed',
          duration: 0,
          timestamp: Date.now()
        })
      }
      
      activeCall.value = null
    }
  }
  
  function updateCallDuration() {
    if (activeCall.value && activeCall.value.startTime && activeCall.value.status === 'active') {
      activeCall.value.duration = Math.floor((Date.now() - activeCall.value.startTime) / 1000)
    }
  }
  
  return {
    // State
    isVisible,
    isUnlocked,
    currentApp,
    phoneData,
    animationState,
    activeCall,
    
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
    updateContact,
    updateCallHistory,
    addCallHistory,
    deleteCallHistory,
    initiateCall,
    receiveCall,
    answerCall,
    endCall,
    updateCallDuration
  }
})
