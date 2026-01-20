<template>
  <div class="calls-app">
    <div class="app-header">
      <h2>Calls</h2>
      <button @click="showDialPad = true" class="dial-button">📞 Dial</button>
    </div>
    
    <div class="calls-content">
      <!-- Call History Tabs -->
      <div class="tabs">
        <button 
          :class="['tab', { active: activeTab === 'all' }]"
          @click="activeTab = 'all'"
        >
          All
        </button>
        <button 
          :class="['tab', { active: activeTab === 'missed' }]"
          @click="activeTab = 'missed'"
        >
          Missed
        </button>
      </div>
      
      <!-- Empty state -->
      <div v-if="filteredCallHistory.length === 0" class="empty-state">
        <div class="empty-icon">📞</div>
        <div class="empty-text">No call history</div>
        <button @click="showDialPad = true" class="empty-button">Make a Call</button>
      </div>
      
      <!-- Call History List -->
      <div v-else class="call-history-list">
        <div 
          v-for="call in filteredCallHistory" 
          :key="call.id"
          class="call-item"
          @click="selectCall(call)"
        >
          <div class="call-icon" :class="`call-${call.type}`">
            <span v-if="call.type === 'incoming'">📥</span>
            <span v-else-if="call.type === 'outgoing'">📤</span>
            <span v-else>📵</span>
          </div>
          <div class="call-info">
            <div class="call-contact">{{ getContactName(call.number) }}</div>
            <div class="call-details">
              <span class="call-number">{{ call.number }}</span>
              <span class="call-time">{{ formatTime(call.timestamp) }}</span>
            </div>
          </div>
          <button @click.stop="callNumber(call.number)" class="quick-call-button">
            📞
          </button>
        </div>
      </div>
    </div>
    
    <!-- Dial Pad Modal -->
    <div v-if="showDialPad" class="modal-overlay" @click.self="closeDialPad">
      <div class="modal-content dial-modal">
        <div class="modal-header">
          <h3>Dial Number</h3>
          <button @click="closeDialPad" class="modal-close">✕</button>
        </div>
        <div class="modal-body">
          <div class="dial-display">
            <input 
              v-model="dialNumber" 
              type="text" 
              placeholder="Enter number"
              maxlength="7"
              class="dial-input"
              @input="validateDialNumber"
            >
          </div>
          
          <div class="dial-pad">
            <button 
              v-for="num in [1, 2, 3, 4, 5, 6, 7, 8, 9, '*', 0, '#']" 
              :key="num"
              @click="addDigit(num)"
              class="dial-key"
            >
              {{ num }}
            </button>
          </div>
          
          <div class="dial-actions">
            <button @click="backspace" class="dial-action-button">⌫</button>
            <button 
              @click="initiateCall" 
              :disabled="!isValidNumber"
              class="dial-action-button dial-call"
              :class="{ disabled: !isValidNumber }"
            >
              📞 Call
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Call Detail Modal -->
    <div v-if="selectedCall" class="modal-overlay" @click.self="closeCallDetail">
      <div class="modal-content modal-detail">
        <div class="modal-header">
          <h3>Call Details</h3>
          <button @click="closeCallDetail" class="modal-close">✕</button>
        </div>
        <div class="modal-body">
          <div class="detail-icon" :class="`call-${selectedCall.type}`">
            <span v-if="selectedCall.type === 'incoming'">📥</span>
            <span v-else-if="selectedCall.type === 'outgoing'">📤</span>
            <span v-else>📵</span>
          </div>
          <div class="detail-contact">{{ getContactName(selectedCall.number) }}</div>
          <div class="detail-number">{{ selectedCall.number }}</div>
          
          <div class="detail-info">
            <div class="detail-item">
              <div class="detail-label">Type</div>
              <div class="detail-value">{{ formatCallType(selectedCall.type) }}</div>
            </div>
            <div class="detail-item">
              <div class="detail-label">Date & Time</div>
              <div class="detail-value">{{ formatFullDate(selectedCall.timestamp) }}</div>
            </div>
            <div class="detail-item" v-if="selectedCall.duration">
              <div class="detail-label">Duration</div>
              <div class="detail-value">{{ formatDuration(selectedCall.duration) }}</div>
            </div>
          </div>
          
          <div class="action-buttons">
            <button @click="callNumber(selectedCall.number)" class="action-button action-call">
              📞 Call Back
            </button>
            <button @click="addToContacts(selectedCall.number)" class="action-button action-contact">
              👤 Add Contact
            </button>
          </div>
        </div>
        <div class="modal-footer">
          <button @click="deleteCallHistory(selectedCall.id)" class="button button-danger">Delete</button>
        </div>
      </div>
    </div>
    
    <!-- Active Call Overlay -->
    <div v-if="phoneStore.activeCall" class="call-overlay">
      <div class="call-screen">
        <div class="call-status">{{ phoneStore.activeCall.status }}</div>
        <div class="call-contact-name">{{ getContactName(phoneStore.activeCall.number) }}</div>
        <div class="call-number">{{ phoneStore.activeCall.number }}</div>
        <div v-if="phoneStore.activeCall.duration" class="call-duration">
          {{ formatDuration(phoneStore.activeCall.duration) }}
        </div>
        
        <div class="call-controls">
          <button v-if="phoneStore.activeCall.status === 'incoming'" @click="answerCall" class="call-control-button call-answer">
            📞 Answer
          </button>
          <button @click="endCall" class="call-control-button call-end">
            📵 End
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { usePhoneStore } from '../../../stores/phone'
import { sendNuiMessage } from '../../../utils/nui'

const phoneStore = usePhoneStore()

// UI state
const showDialPad = ref(false)
const selectedCall = ref(null)
const activeTab = ref('all')
const dialNumber = ref('')

// Computed
const filteredCallHistory = computed(() => {
  if (activeTab.value === 'missed') {
    return phoneStore.phoneData.callHistory.filter(call => call.type === 'missed')
  }
  return phoneStore.phoneData.callHistory
})

const isValidNumber = computed(() => {
  return dialNumber.value.length >= 6 && dialNumber.value.length <= 7 && /^\d+$/.test(dialNumber.value)
})

// Get contact name from number
const getContactName = (number) => {
  const contact = phoneStore.phoneData.contacts.find(c => c.number === number)
  return contact ? contact.name : number
}

// Format time (relative)
const formatTime = (timestamp) => {
  const date = new Date(timestamp)
  const now = new Date()
  const diffMs = now - date
  const diffMins = Math.floor(diffMs / 60000)
  const diffHours = Math.floor(diffMs / 3600000)
  const diffDays = Math.floor(diffMs / 86400000)
  
  if (diffMins < 1) return 'Just now'
  if (diffMins < 60) return `${diffMins}m ago`
  if (diffHours < 24) return `${diffHours}h ago`
  if (diffDays === 1) return 'Yesterday'
  if (diffDays < 7) return `${diffDays}d ago`
  
  return date.toLocaleDateString()
}

// Format full date
const formatFullDate = (timestamp) => {
  const date = new Date(timestamp)
  return date.toLocaleString('en-US', { 
    month: 'long', 
    day: 'numeric', 
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// Format call type
const formatCallType = (type) => {
  const types = {
    incoming: 'Incoming Call',
    outgoing: 'Outgoing Call',
    missed: 'Missed Call'
  }
  return types[type] || type
}

// Format duration (seconds to mm:ss)
const formatDuration = (seconds) => {
  if (!seconds) return '0:00'
  const mins = Math.floor(seconds / 60)
  const secs = seconds % 60
  return `${mins}:${secs.toString().padStart(2, '0')}`
}

// Validate dial number (digits only)
const validateDialNumber = () => {
  dialNumber.value = dialNumber.value.replace(/\D/g, '')
}

// Add digit to dial number
const addDigit = (digit) => {
  if (dialNumber.value.length < 7) {
    dialNumber.value += digit.toString()
  }
}

// Backspace digit
const backspace = () => {
  dialNumber.value = dialNumber.value.slice(0, -1)
}

// Select call for viewing details
const selectCall = (call) => {
  selectedCall.value = call
}

// Close call detail
const closeCallDetail = () => {
  selectedCall.value = null
}

// Close dial pad
const closeDialPad = () => {
  showDialPad.value = false
  dialNumber.value = ''
}

// Initiate call from dial pad
const initiateCall = () => {
  if (!isValidNumber.value) return
  
  callNumber(dialNumber.value)
  closeDialPad()
}

// Call a number
const callNumber = (number) => {
  if (!phoneStore.phoneData.imei) return
  
  sendNuiMessage('NUI:Client:PhoneInitiateCall', {
    imei: phoneStore.phoneData.imei,
    number: number
  })
  
  phoneStore.initiateCall(number)
}

// Answer incoming call
const answerCall = () => {
  if (!phoneStore.activeCall) return
  
  sendNuiMessage('NUI:Client:PhoneAnswerCall', {
    imei: phoneStore.phoneData.imei,
    callId: phoneStore.activeCall.id
  })
  
  phoneStore.answerCall()
}

// End active call
const endCall = () => {
  if (!phoneStore.activeCall) return
  
  sendNuiMessage('NUI:Client:PhoneEndCall', {
    imei: phoneStore.phoneData.imei,
    callId: phoneStore.activeCall.id
  })
  
  phoneStore.endCall()
}

// Add number to contacts
const addToContacts = (number) => {
  // Open contacts app with pre-filled number
  phoneStore.openApp('contacts')
  closeCallDetail()
}

// Delete call history entry
const deleteCallHistory = (callId) => {
  if (confirm('Delete this call from history?')) {
    sendNuiMessage('NUI:Client:PhoneDeleteCallHistory', {
      imei: phoneStore.phoneData.imei,
      callId: callId
    })
    
    phoneStore.deleteCallHistory(callId)
    closeCallDetail()
  }
}
</script>

<style scoped>
.calls-app {
  height: 100%;
  display: flex;
  flex-direction: column;
  position: relative;
}

.app-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  background: rgba(255, 255, 255, 0.05);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.app-header h2 {
  margin: 0;
  color: white;
  font-size: 24px;
  font-weight: 600;
}

.dial-button {
  padding: 8px 16px;
  background: #10b981;
  border: none;
  border-radius: 8px;
  color: white;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}

.dial-button:hover {
  background: #059669;
}

.calls-content {
  flex: 1;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

/* Tabs */
.tabs {
  display: flex;
  background: rgba(255, 255, 255, 0.05);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.tab {
  flex: 1;
  padding: 12px;
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  border-bottom: 2px solid transparent;
}

.tab:hover {
  color: rgba(255, 255, 255, 0.8);
}

.tab.active {
  color: white;
  border-bottom-color: #10b981;
}

/* Empty state */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  flex: 1;
  gap: 16px;
  padding: 40px 20px;
}

.empty-icon {
  font-size: 64px;
  opacity: 0.3;
}

.empty-text {
  color: rgba(255, 255, 255, 0.6);
  font-size: 16px;
}

.empty-button {
  padding: 12px 24px;
  background: #10b981;
  border: none;
  border-radius: 12px;
  color: white;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}

.empty-button:hover {
  background: #059669;
}

/* Call history list */
.call-history-list {
  display: flex;
  flex-direction: column;
  gap: 1px;
  padding: 10px;
}

.call-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.2s;
}

.call-item:hover {
  background: rgba(255, 255, 255, 0.08);
}

.call-icon {
  width: 48px;
  height: 48px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  flex-shrink: 0;
}

.call-icon.call-incoming {
  background: rgba(16, 185, 129, 0.2);
}

.call-icon.call-outgoing {
  background: rgba(59, 130, 246, 0.2);
}

.call-icon.call-missed {
  background: rgba(239, 68, 68, 0.2);
}

.call-info {
  flex: 1;
}

.call-contact {
  color: white;
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 4px;
}

.call-details {
  display: flex;
  gap: 12px;
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
}

.quick-call-button {
  width: 40px;
  height: 40px;
  background: rgba(16, 185, 129, 0.2);
  border: none;
  border-radius: 50%;
  color: #10b981;
  font-size: 18px;
  cursor: pointer;
  transition: all 0.2s;
  flex-shrink: 0;
}

.quick-call-button:hover {
  background: rgba(16, 185, 129, 0.3);
  transform: scale(1.1);
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background: #1a1a1a;
  border-radius: 16px;
  width: 100%;
  max-width: 320px;
  max-height: 90%;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header h3 {
  margin: 0;
  color: white;
  font-size: 20px;
  font-weight: 600;
}

.modal-close {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  font-size: 24px;
  cursor: pointer;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  transition: all 0.2s;
}

.modal-close:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.modal-body {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.modal-footer {
  display: flex;
  gap: 12px;
  padding: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

/* Dial pad */
.dial-modal .modal-body {
  padding: 20px;
}

.dial-display {
  margin-bottom: 20px;
}

.dial-input {
  width: 100%;
  padding: 16px;
  background: rgba(255, 255, 255, 0.05);
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  color: white;
  font-size: 24px;
  text-align: center;
  font-weight: 600;
  letter-spacing: 2px;
}

.dial-input:focus {
  outline: none;
  border-color: #10b981;
  background: rgba(255, 255, 255, 0.08);
}

.dial-pad {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  margin-bottom: 20px;
}

.dial-key {
  aspect-ratio: 1;
  background: rgba(255, 255, 255, 0.1);
  border: none;
  border-radius: 50%;
  color: white;
  font-size: 24px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.dial-key:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: scale(1.05);
}

.dial-key:active {
  transform: scale(0.95);
}

.dial-actions {
  display: flex;
  gap: 12px;
}

.dial-action-button {
  flex: 1;
  padding: 16px;
  border: none;
  border-radius: 12px;
  color: white;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.dial-action-button:first-child {
  background: rgba(255, 255, 255, 0.1);
}

.dial-action-button.dial-call {
  background: #10b981;
  flex: 2;
}

.dial-action-button.dial-call:hover:not(.disabled) {
  background: #059669;
}

.dial-action-button.disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

/* Call detail */
.modal-detail .modal-body {
  text-align: center;
}

.detail-icon {
  width: 80px;
  height: 80px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40px;
  margin: 0 auto 16px;
}

.detail-icon.call-incoming {
  background: rgba(16, 185, 129, 0.2);
}

.detail-icon.call-outgoing {
  background: rgba(59, 130, 246, 0.2);
}

.detail-icon.call-missed {
  background: rgba(239, 68, 68, 0.2);
}

.detail-contact {
  color: white;
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 8px;
}

.detail-number {
  color: rgba(255, 255, 255, 0.6);
  font-size: 16px;
  margin-bottom: 24px;
}

.detail-info {
  text-align: left;
  margin-bottom: 24px;
}

.detail-item {
  padding: 12px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.detail-item:last-child {
  border-bottom: none;
}

.detail-label {
  color: rgba(255, 255, 255, 0.6);
  font-size: 12px;
  font-weight: 500;
  margin-bottom: 4px;
}

.detail-value {
  color: white;
  font-size: 16px;
  font-weight: 600;
}

.action-buttons {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
}

.action-button {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.action-button.action-call {
  background: rgba(16, 185, 129, 0.2);
  color: #10b981;
}

.action-button.action-call:hover {
  background: rgba(16, 185, 129, 0.3);
}

.action-button.action-contact {
  background: rgba(59, 130, 246, 0.2);
  color: #60a5fa;
}

.action-button.action-contact:hover {
  background: rgba(59, 130, 246, 0.3);
}

/* Buttons */
.button {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.button-danger {
  background: rgba(220, 38, 38, 0.2);
  color: #f87171;
}

.button-danger:hover {
  background: rgba(220, 38, 38, 0.3);
}

/* Active call overlay */
.call-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.95);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.call-screen {
  text-align: center;
  padding: 40px;
}

.call-status {
  color: rgba(255, 255, 255, 0.6);
  font-size: 16px;
  margin-bottom: 20px;
  text-transform: uppercase;
  letter-spacing: 2px;
}

.call-contact-name {
  color: white;
  font-size: 32px;
  font-weight: 700;
  margin-bottom: 8px;
}

.call-number {
  color: rgba(255, 255, 255, 0.6);
  font-size: 20px;
  margin-bottom: 20px;
}

.call-duration {
  color: white;
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 40px;
}

.call-controls {
  display: flex;
  gap: 20px;
  justify-content: center;
}

.call-control-button {
  width: 80px;
  height: 80px;
  border: none;
  border-radius: 50%;
  color: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.call-control-button:hover {
  transform: scale(1.05);
}

.call-control-button:active {
  transform: scale(0.95);
}

.call-answer {
  background: #10b981;
}

.call-answer:hover {
  background: #059669;
}

.call-end {
  background: #dc2626;
}

.call-end:hover {
  background: #b91c1c;
}

/* Scrollbar */
.calls-content::-webkit-scrollbar,
.modal-body::-webkit-scrollbar {
  width: 6px;
}

.calls-content::-webkit-scrollbar-track,
.modal-body::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
}

.calls-content::-webkit-scrollbar-thumb,
.modal-body::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.calls-content::-webkit-scrollbar-thumb:hover,
.modal-body::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>
