<template>
  <div class="email-app">
    <!-- Login/Register View -->
    <div v-if="!isLoggedIn" class="email-auth">
      <div class="auth-header">
        <div class="auth-icon">📧</div>
        <h2>{{ isRegistering ? 'Create Email Account' : 'Email Login' }}</h2>
      </div>
      
      <div class="auth-content">
        <div class="form-group">
          <label>Email Address</label>
          <input 
            v-model="emailForm.email" 
            type="text" 
            placeholder="user@domain.com"
            class="form-input"
            @input="validateEmail"
          >
          <div v-if="emailError" class="error-message">{{ emailError }}</div>
        </div>
        
        <div class="form-group">
          <label>Password</label>
          <input 
            v-model="emailForm.password" 
            type="password" 
            placeholder="Enter password"
            class="form-input"
          >
        </div>
        
        <button @click="handleAuth" class="btn btn-primary">
          {{ isRegistering ? 'Create Account' : 'Login' }}
        </button>
        
        <button @click="toggleAuthMode" class="btn btn-secondary">
          {{ isRegistering ? 'Already have an account? Login' : 'Need an account? Register' }}
        </button>
      </div>
    </div>
    
    <!-- Email Interface -->
    <div v-else class="email-interface">
      <div class="app-header">
        <h2>Email</h2>
        <div class="header-actions">
          <button @click="showCompose = true" class="btn-compose">✍️ Compose</button>
          <button @click="logout" class="btn-logout">Logout</button>
        </div>
      </div>
      
      <!-- Email Tabs -->
      <div class="email-tabs">
        <button 
          @click="currentTab = 'inbox'" 
          class="tab-button"
          :class="{ active: currentTab === 'inbox' }"
        >
          📥 Inbox {{ unreadCount > 0 ? `(${unreadCount})` : '' }}
        </button>
        <button 
          @click="currentTab = 'sent'" 
          class="tab-button"
          :class="{ active: currentTab === 'sent' }"
        >
          📤 Sent
        </button>
      </div>
      
      <!-- Future Features (Greyed Out) -->
      <div class="future-features">
        <button class="feature-disabled" disabled>💬 Reply</button>
        <button class="feature-disabled" disabled>↪️ Forward</button>
        <button class="feature-disabled" disabled>🔗 Chains</button>
      </div>
      
      <!-- Email List -->
      <div class="email-list">
        <!-- Inbox -->
        <div v-if="currentTab === 'inbox'">
          <div v-if="inbox.length === 0" class="empty-state">
            <div class="empty-icon">📭</div>
            <div class="empty-text">No emails in inbox</div>
          </div>
          
          <div v-else>
            <div 
              v-for="email in inbox" 
              :key="email.ID"
              class="email-item"
              :class="{ unread: !email.Read_Status }"
              @click="openEmail(email)"
            >
              <div class="email-info">
                <div class="email-sender">
                  <span class="sender-name">{{ email.Sender }}</span>
                  <span v-if="!email.Read_Status" class="unread-badge">New</span>
                </div>
                <div class="email-subject">{{ email.Subject || '(No Subject)' }}</div>
                <div class="email-preview">{{ getPreview(email.Message) }}</div>
              </div>
              <div class="email-time">{{ formatTime(email.Sent_At) }}</div>
            </div>
          </div>
        </div>
        
        <!-- Sent -->
        <div v-if="currentTab === 'sent'">
          <div v-if="sent.length === 0" class="empty-state">
            <div class="empty-icon">📪</div>
            <div class="empty-text">No sent emails</div>
          </div>
          
          <div v-else>
            <div 
              v-for="email in sent" 
              :key="email.ID"
              class="email-item"
              @click="openEmail(email)"
            >
              <div class="email-info">
                <div class="email-sender">
                  <span class="sender-name">To: {{ email.Recipient }}</span>
                </div>
                <div class="email-subject">{{ email.Subject || '(No Subject)' }}</div>
                <div class="email-preview">{{ getPreview(email.Message) }}</div>
              </div>
              <div class="email-time">{{ formatTime(email.Sent_At) }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Compose Email Modal -->
    <div v-if="showCompose" class="modal-overlay" @click.self="closeCompose">
      <div class="modal-content modal-large">
        <div class="modal-header">
          <h3>Compose Email</h3>
          <button @click="closeCompose" class="modal-close">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>To:</label>
            <input 
              v-model="composeForm.recipient" 
              type="text" 
              placeholder="recipient@domain.com"
              class="form-input"
            >
          </div>
          <div class="form-group">
            <label>Subject:</label>
            <input 
              v-model="composeForm.subject" 
              type="text" 
              placeholder="Email subject"
              maxlength="200"
              class="form-input"
            >
          </div>
          <div class="form-group">
            <label>Message:</label>
            <textarea 
              v-model="composeForm.message" 
              placeholder="Write your message here..."
              class="form-textarea"
              rows="8"
            ></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button @click="closeCompose" class="button button-secondary">Cancel</button>
          <button @click="sendEmail" class="button button-primary">📤 Send</button>
        </div>
      </div>
    </div>
    
    <!-- View Email Modal -->
    <div v-if="selectedEmail" class="modal-overlay" @click.self="closeEmail">
      <div class="modal-content modal-large">
        <div class="modal-header">
          <h3>{{ selectedEmail.Subject || '(No Subject)' }}</h3>
          <button @click="closeEmail" class="modal-close">✕</button>
        </div>
        <div class="modal-body">
          <div class="email-detail-header">
            <div class="detail-row">
              <span class="detail-label">From:</span>
              <span class="detail-value">{{ selectedEmail.Sender }}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">To:</span>
              <span class="detail-value">{{ selectedEmail.Recipient }}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Date:</span>
              <span class="detail-value">{{ formatFullTime(selectedEmail.Sent_At) }}</span>
            </div>
          </div>
          
          <div class="email-detail-body">
            {{ selectedEmail.Message }}
          </div>
        </div>
        <div class="modal-footer">
          <button @click="closeEmail" class="button button-secondary">Close</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { usePhoneStore } from '../../../stores/phone'
import { sendNuiMessage } from '../../../utils/nui'

const phoneStore = usePhoneStore()

// Auth state
const isLoggedIn = ref(false)
const isRegistering = ref(false)
const currentUserEmail = ref('')

// Email state
const currentTab = ref('inbox')
const inbox = ref([])
const sent = ref([])

// UI state
const showCompose = ref(false)
const selectedEmail = ref(null)

// Forms
const emailForm = ref({
  email: '',
  password: ''
})

const composeForm = ref({
  recipient: '',
  subject: '',
  message: ''
})

// Email validation
const emailError = ref('')

const validateEmail = () => {
  const email = emailForm.value.email
  emailError.value = ''
  
  if (!email) {
    return
  }
  
  // Check for @ symbol
  if (!email.includes('@')) {
    emailError.value = 'Email must contain @'
    return
  }
  
  // Split by @
  const parts = email.split('@')
  if (parts.length !== 2) {
    emailError.value = 'Email must contain exactly one @'
    return
  }
  
  const [username, domain] = parts
  
  // Check username length (min 3 chars)
  if (username.length < 3) {
    emailError.value = 'Username must be at least 3 characters'
    return
  }
  
  // Check for invalid characters (only alphanumeric, dot, and @ allowed)
  const validPattern = /^[a-zA-Z0-9.]+@[a-zA-Z0-9.]+\.[a-zA-Z]{2,}$/
  if (!validPattern.test(email)) {
    emailError.value = 'Invalid characters in email. Only letters, numbers, and . allowed'
    return
  }
  
  // Check domain has at least one dot
  if (!domain.includes('.')) {
    emailError.value = 'Domain must contain at least one .'
    return
  }
}

// Toggle between login and register
const toggleAuthMode = () => {
  isRegistering.value = !isRegistering.value
  emailError.value = ''
}

// Handle authentication
const handleAuth = () => {
  validateEmail()
  
  if (emailError.value) {
    return
  }
  
  if (!emailForm.value.email || !emailForm.value.password) {
    emailError.value = 'Email and password are required'
    return
  }
  
  if (isRegistering.value) {
    // Register new account
    sendNuiMessage('NUI:Client:EmailRegister', {
      email: emailForm.value.email,
      password: emailForm.value.password
    })
  } else {
    // Login
    sendNuiMessage('NUI:Client:EmailLogin', {
      email: emailForm.value.email,
      password: emailForm.value.password
    })
  }
}

// Logout
const logout = () => {
  isLoggedIn.value = false
  currentUserEmail.value = ''
  inbox.value = []
  sent.value = []
  emailForm.value = { email: '', password: '' }
  
  sendNuiMessage('NUI:Client:EmailLogout')
}

// Send email
const sendEmail = () => {
  if (!composeForm.value.recipient || !composeForm.value.message) {
    return
  }
  
  sendNuiMessage('NUI:Client:EmailSend', {
    sender: currentUserEmail.value,
    recipient: composeForm.value.recipient,
    subject: composeForm.value.subject,
    message: composeForm.value.message
  })
  
  closeCompose()
}

// Open email
const openEmail = (email) => {
  selectedEmail.value = email
  
  // Mark as read if inbox email
  if (currentTab.value === 'inbox' && !email.Read_Status) {
    sendNuiMessage('NUI:Client:EmailMarkRead', {
      emailId: email.ID
    })
    
    // Update local state
    email.Read_Status = 1
  }
}

// Close email
const closeEmail = () => {
  selectedEmail.value = null
}

// Close compose
const closeCompose = () => {
  showCompose.value = false
  composeForm.value = {
    recipient: '',
    subject: '',
    message: ''
  }
}

// Get message preview (first 60 chars)
const getPreview = (message) => {
  if (!message) return ''
  return message.length > 60 ? message.substring(0, 60) + '...' : message
}

// Format time
const formatTime = (timestamp) => {
  const date = new Date(timestamp)
  const now = new Date()
  const diff = now - date
  
  // Less than 24 hours
  if (diff < 86400000) {
    return date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })
  }
  
  // Less than 7 days
  if (diff < 604800000) {
    return date.toLocaleDateString('en-US', { weekday: 'short' })
  }
  
  // Older
  return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
}

// Format full time
const formatFullTime = (timestamp) => {
  const date = new Date(timestamp)
  return date.toLocaleString('en-US', {
    month: 'long',
    day: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// Computed
const unreadCount = computed(() => {
  return inbox.value.filter(email => !email.Read_Status).length
})

// Listen for email updates from server
window.addEventListener('message', (event) => {
  const data = event.data
  
  if (data.type === 'email:loginSuccess') {
    isLoggedIn.value = true
    currentUserEmail.value = data.email
    inbox.value = data.inbox || []
    sent.value = data.sent || []
  } else if (data.type === 'email:registerSuccess') {
    isLoggedIn.value = true
    currentUserEmail.value = data.email
    inbox.value = []
    sent.value = []
  } else if (data.type === 'email:loginError' || data.type === 'email:registerError') {
    emailError.value = data.message || 'Authentication failed'
  } else if (data.type === 'email:inboxUpdated') {
    inbox.value = data.inbox || []
  } else if (data.type === 'email:sentUpdated') {
    sent.value = data.sent || []
  }
})
</script>

<style scoped>
.email-app {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #1a1a1a;
}

/* Auth View */
.email-auth {
  height: 100%;
  display: flex;
  flex-direction: column;
  padding: 40px 20px;
}

.auth-header {
  text-align: center;
  margin-bottom: 32px;
}

.auth-icon {
  font-size: 64px;
  margin-bottom: 16px;
}

.auth-header h2 {
  margin: 0;
  color: white;
  font-size: 24px;
  font-weight: 600;
}

.auth-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* Email Interface */
.email-interface {
  height: 100%;
  display: flex;
  flex-direction: column;
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

.header-actions {
  display: flex;
  gap: 8px;
}

.btn-compose {
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

.btn-compose:hover {
  background: #059669;
}

.btn-logout {
  padding: 8px 16px;
  background: rgba(239, 68, 68, 0.2);
  border: none;
  border-radius: 8px;
  color: #f87171;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-logout:hover {
  background: rgba(239, 68, 68, 0.3);
}

/* Tabs */
.email-tabs {
  display: flex;
  background: rgba(0, 0, 0, 0.3);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.tab-button {
  flex: 1;
  padding: 16px;
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  border-bottom: 2px solid transparent;
}

.tab-button:hover {
  background: rgba(255, 255, 255, 0.05);
  color: rgba(255, 255, 255, 0.8);
}

.tab-button.active {
  color: white;
  border-bottom-color: #10b981;
  background: rgba(255, 255, 255, 0.05);
}

/* Future Features */
.future-features {
  display: flex;
  gap: 8px;
  padding: 12px 20px;
  background: rgba(0, 0, 0, 0.2);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.feature-disabled {
  padding: 6px 12px;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 6px;
  color: rgba(255, 255, 255, 0.3);
  font-size: 12px;
  font-weight: 600;
  cursor: not-allowed;
  opacity: 0.5;
}

/* Email List */
.email-list {
  flex: 1;
  overflow-y: auto;
}

.email-item {
  display: flex;
  justify-content: space-between;
  align-items: start;
  padding: 16px 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  cursor: pointer;
  transition: background 0.2s;
}

.email-item:hover {
  background: rgba(255, 255, 255, 0.05);
}

.email-item.unread {
  background: rgba(59, 130, 246, 0.05);
}

.email-item.unread:hover {
  background: rgba(59, 130, 246, 0.08);
}

.email-info {
  flex: 1;
}

.email-sender {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}

.sender-name {
  color: white;
  font-size: 14px;
  font-weight: 600;
}

.unread-badge {
  padding: 2px 8px;
  background: rgba(59, 130, 246, 0.3);
  border-radius: 10px;
  color: #60a5fa;
  font-size: 10px;
  font-weight: 700;
}

.email-subject {
  color: rgba(255, 255, 255, 0.9);
  font-size: 13px;
  font-weight: 500;
  margin-bottom: 4px;
}

.email-preview {
  color: rgba(255, 255, 255, 0.5);
  font-size: 12px;
}

.email-time {
  color: rgba(255, 255, 255, 0.4);
  font-size: 11px;
  white-space: nowrap;
  margin-left: 12px;
}

/* Empty State */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  gap: 16px;
}

.empty-icon {
  font-size: 64px;
  opacity: 0.3;
}

.empty-text {
  color: rgba(255, 255, 255, 0.6);
  font-size: 16px;
}

/* Form */
.form-group {
  margin-bottom: 16px;
}

.form-group label {
  display: block;
  color: rgba(255, 255, 255, 0.8);
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 8px;
}

.form-input,
.form-textarea {
  width: 100%;
  padding: 12px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  font-size: 14px;
  transition: all 0.2s;
  font-family: inherit;
}

.form-input:focus,
.form-textarea:focus {
  outline: none;
  border-color: #10b981;
  background: rgba(255, 255, 255, 0.08);
}

.form-textarea {
  resize: vertical;
  min-height: 100px;
}

.error-message {
  color: #f87171;
  font-size: 12px;
  margin-top: 4px;
}

/* Buttons */
.btn {
  width: 100%;
  padding: 12px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background: #10b981;
  color: white;
}

.btn-primary:hover {
  background: #059669;
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.8);
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.15);
}

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

.button-primary {
  background: #10b981;
  color: white;
}

.button-primary:hover {
  background: #059669;
}

.button-secondary {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.button-secondary:hover {
  background: rgba(255, 255, 255, 0.15);
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

.modal-content.modal-large {
  max-width: 340px;
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

/* Email Detail */
.email-detail-header {
  background: rgba(255, 255, 255, 0.03);
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 20px;
}

.detail-row {
  display: flex;
  padding: 8px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.detail-row:last-child {
  border-bottom: none;
}

.detail-label {
  color: rgba(255, 255, 255, 0.6);
  font-size: 13px;
  font-weight: 600;
  width: 60px;
}

.detail-value {
  color: white;
  font-size: 13px;
  flex: 1;
}

.email-detail-body {
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
  line-height: 1.6;
  white-space: pre-wrap;
  word-break: break-word;
}

/* Scrollbar */
.email-list::-webkit-scrollbar,
.modal-body::-webkit-scrollbar {
  width: 6px;
}

.email-list::-webkit-scrollbar-track,
.modal-body::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
}

.email-list::-webkit-scrollbar-thumb,
.modal-body::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.email-list::-webkit-scrollbar-thumb:hover,
.modal-body::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>
