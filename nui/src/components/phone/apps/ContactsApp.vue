<template>
  <div class="contacts-app">
    <div class="app-header">
      <h2>Contacts</h2>
      <button @click="showAddContact = true" class="add-button">+ Add</button>
    </div>
    
    <div class="contacts-content">
      <!-- Empty state -->
      <div v-if="phoneStore.phoneData.contacts.length === 0" class="empty-state">
        <div class="empty-icon">👤</div>
        <div class="empty-text">No contacts yet</div>
        <button @click="showAddContact = true" class="empty-button">Add Contact</button>
      </div>
      
      <!-- Contacts list -->
      <div v-else class="contacts-list">
        <div 
          v-for="contact in phoneStore.phoneData.contacts" 
          :key="contact.id"
          class="contact-item"
          @click="selectContact(contact)"
        >
          <div class="contact-avatar">{{ getContactInitials(contact.name) }}</div>
          <div class="contact-info">
            <div class="contact-name">{{ contact.name }}</div>
            <div class="contact-number">{{ contact.number }}</div>
          </div>
          <div class="contact-type-badge" :class="`badge-${contact.type}`">
            {{ contact.type }}
          </div>
        </div>
      </div>
    </div>
    
    <!-- Add Contact Modal -->
    <div v-if="showAddContact" class="modal-overlay" @click.self="closeAddContact">
      <div class="modal-content">
        <div class="modal-header">
          <h3>{{ editingContact ? 'Edit Contact' : 'Add Contact' }}</h3>
          <button @click="closeAddContact" class="modal-close">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>Name *</label>
            <input 
              v-model="contactForm.name" 
              type="text" 
              placeholder="John Doe"
              maxlength="50"
              class="form-input"
            >
          </div>
          <div class="form-group">
            <label>Phone Number *</label>
            <input 
              v-model="contactForm.number" 
              type="text" 
              placeholder="123456"
              maxlength="7"
              class="form-input"
            >
          </div>
          <div class="form-group">
            <label>Type</label>
            <select v-model="contactForm.type" class="form-select">
              <option value="personal">Personal</option>
              <option value="work">Work</option>
            </select>
          </div>
          <div class="form-group">
            <label>Email (optional)</label>
            <input 
              v-model="contactForm.email" 
              type="email" 
              placeholder="john@example.com"
              maxlength="100"
              class="form-input"
            >
          </div>
        </div>
        <div class="modal-footer">
          <button @click="closeAddContact" class="button button-secondary">Cancel</button>
          <button @click="saveContact" class="button button-primary">Save</button>
        </div>
      </div>
    </div>
    
    <!-- Contact Detail Modal -->
    <div v-if="selectedContact" class="modal-overlay" @click.self="closeContactDetail">
      <div class="modal-content modal-detail">
        <div class="modal-header">
          <h3>Contact Details</h3>
          <button @click="closeContactDetail" class="modal-close">✕</button>
        </div>
        <div class="modal-body">
          <div class="detail-avatar">{{ getContactInitials(selectedContact.name) }}</div>
          <div class="detail-name">{{ selectedContact.name }}</div>
          <div class="detail-type-badge" :class="`badge-${selectedContact.type}`">
            {{ selectedContact.type }}
          </div>
          
          <div class="detail-info">
            <div class="detail-item">
              <div class="detail-label">Phone Number</div>
              <div class="detail-value">{{ selectedContact.number }}</div>
            </div>
            <div class="detail-item" v-if="selectedContact.email">
              <div class="detail-label">Email</div>
              <div class="detail-value">{{ selectedContact.email }}</div>
            </div>
          </div>
          
          <div class="action-buttons">
            <button class="action-button action-disabled" disabled>
              📱 Call
            </button>
            <button class="action-button action-disabled" disabled>
              💬 Message
            </button>
          </div>
        </div>
        <div class="modal-footer">
          <button @click="deleteContact(selectedContact.id)" class="button button-danger">Delete</button>
          <button @click="editContact(selectedContact)" class="button button-secondary">Edit</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { usePhoneStore } from '../../../stores/phone'
import { sendNuiMessage } from '../../../utils/nui'

const phoneStore = usePhoneStore()

// UI state
const showAddContact = ref(false)
const selectedContact = ref(null)
const editingContact = ref(null)

// Contact form
const contactForm = ref({
  name: '',
  number: '',
  type: 'personal',
  email: ''
})

// Get contact initials for avatar
const getContactInitials = (name) => {
  const names = name.split(' ')
  if (names.length === 1) {
    return names[0].charAt(0).toUpperCase()
  }
  return (names[0].charAt(0) + names[names.length - 1].charAt(0)).toUpperCase()
}

// Select contact for viewing
const selectContact = (contact) => {
  selectedContact.value = contact
}

// Close contact detail
const closeContactDetail = () => {
  selectedContact.value = null
}

// Open edit contact
const editContact = (contact) => {
  editingContact.value = contact
  contactForm.value = {
    name: contact.name,
    number: contact.number,
    type: contact.type,
    email: contact.email || ''
  }
  selectedContact.value = null
  showAddContact.value = true
}

// Close add/edit contact
const closeAddContact = () => {
  showAddContact.value = false
  editingContact.value = null
  contactForm.value = {
    name: '',
    number: '',
    type: 'personal',
    email: ''
  }
}

// Save contact
const saveContact = () => {
  // Validate
  if (!contactForm.value.name || !contactForm.value.number) {
    return
  }
  
  if (editingContact.value) {
    // Update existing contact
    sendNuiMessage('NUI:Client:PhoneUpdateContact', {
      contactId: editingContact.value.id,
      contact: contactForm.value
    })
    
    // Update local store
    phoneStore.updateContact(editingContact.value.id, contactForm.value)
  } else {
    // Add new contact
    sendNuiMessage('NUI:Client:PhoneAddContact', {
      contact: contactForm.value
    })
    
    // Update local store (server will send back updated list with ID)
    phoneStore.addContact({
      id: Date.now().toString(), // Temporary ID until server responds
      ...contactForm.value
    })
  }
  
  closeAddContact()
}

// Delete contact
const deleteContact = (contactId) => {
  if (confirm('Are you sure you want to delete this contact?')) {
    sendNuiMessage('NUI:Client:PhoneDeleteContact', {
      contactId: contactId
    })
    
    // Update local store
    phoneStore.removeContact(contactId)
    
    closeContactDetail()
  }
}
</script>

<style scoped>
.contacts-app {
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

.add-button {
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

.add-button:hover {
  background: #059669;
}

.contacts-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

/* Empty state */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
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

/* Contacts list */
.contacts-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.2s;
}

.contact-item:hover {
  background: rgba(255, 255, 255, 0.08);
}

.contact-avatar {
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 18px;
  font-weight: 700;
  flex-shrink: 0;
}

.contact-info {
  flex: 1;
}

.contact-name {
  color: white;
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 4px;
}

.contact-number {
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
}

.contact-type-badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  text-transform: capitalize;
}

.badge-personal {
  background: rgba(59, 130, 246, 0.2);
  color: #60a5fa;
}

.badge-work {
  background: rgba(239, 68, 68, 0.2);
  color: #f87171;
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
.form-select {
  width: 100%;
  padding: 12px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  font-size: 14px;
  transition: all 0.2s;
}

.form-input:focus,
.form-select:focus {
  outline: none;
  border-color: #10b981;
  background: rgba(255, 255, 255, 0.08);
}

.form-input::placeholder {
  color: rgba(255, 255, 255, 0.3);
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

.button-danger {
  background: rgba(220, 38, 38, 0.2);
  color: #f87171;
}

.button-danger:hover {
  background: rgba(220, 38, 38, 0.3);
}

/* Contact detail */
.modal-detail .modal-body {
  text-align: center;
}

.detail-avatar {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 32px;
  font-weight: 700;
  margin: 0 auto 16px;
}

.detail-name {
  color: white;
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 8px;
}

.detail-type-badge {
  display: inline-block;
  padding: 4px 16px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  text-transform: capitalize;
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
  background: rgba(16, 185, 129, 0.2);
  border: none;
  border-radius: 12px;
  color: #10b981;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.action-button:hover:not(.action-disabled) {
  background: rgba(16, 185, 129, 0.3);
}

.action-button.action-disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

/* Scrollbar */
.contacts-content::-webkit-scrollbar,
.modal-body::-webkit-scrollbar {
  width: 6px;
}

.contacts-content::-webkit-scrollbar-track,
.modal-body::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
}

.contacts-content::-webkit-scrollbar-thumb,
.modal-body::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.contacts-content::-webkit-scrollbar-thumb:hover,
.modal-body::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>
