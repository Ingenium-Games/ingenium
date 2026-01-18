<template>
  <div class="character-select">
    <!-- Character Creation Form -->
    <div v-if="characterStore.isCreatingCharacter" class="character-select-make">
      <form @submit.prevent="createCharacter" autocomplete="off">
        <fieldset class="character-select-fieldset">
          <h2 class="text-2xl font-bold mb-6 text-white">Create Character</h2>
          
          <div class="form-group">
            <label>First Name</label>
            <input
              v-model="newCharacter.firstName"
              type="text"
              placeholder="Enter first name"
              pattern="[A-Za-z]{2,25}"
              minlength="2"
              maxlength="25"
              required
            />
          </div>
          
          <div class="form-group">
            <label>Last Name</label>
            <input
              v-model="newCharacter.lastName"
              type="text"
              placeholder="Enter last name"
              pattern="[A-Za-z]{2,25}"
              minlength="2"
              maxlength="25"
              required
            />
          </div>
          
          <div class="form-actions">
            <button type="submit" class="btn-create">Create</button>
            <button type="button" @click.prevent.stop="cancelCreate" class="btn-cancel">Cancel</button>
          </div>
        </fieldset>
      </form>
    </div>
    
    <!-- Character Selection -->
    <div v-else class="character-select-main">
      <!-- Character Info -->
      <div v-if="characterStore.selectedCharacter" class="character-select-info">
        <div class="character-select-information">
          <h2 class="text-2xl font-bold mb-4 text-white">Character Information</h2>
          
          <div class="info-item">
            <h3>Name:</h3>
            <p>{{ characterStore.selectedCharacter.name }}</p>
          </div>
          
          <div class="info-item">
            <h3>Created on:</h3>
            <p>{{ formatDate(characterStore.selectedCharacter.created) }}</p>
          </div>
          
          <div class="info-item">
            <h3>Last played:</h3>
            <p>{{ formatDate(characterStore.selectedCharacter.lastSeen) }}</p>
          </div>
          
          <div class="info-item">
            <h3>City ID:</h3>
            <p>{{ characterStore.selectedCharacter.cityId }}</p>
          </div>
          
          <div class="info-item" v-if="characterStore.selectedCharacter.phone">
            <h3>Phone Number:</h3>
            <p>{{ characterStore.selectedCharacter.phone }}</p>
          </div>
        </div>
      </div>
      
      <!-- Character Options -->
      <div v-if="characterStore.selectedCharacter" class="character-select-options">
        <button @click="playCharacter" class="option-btn play" title="Enter">
          <span class="icon">▶</span>
          <span class="label">Enter</span>
        </button>
        <button @click="deleteCharacter" class="option-btn delete" title="Delete">
          <span class="icon">✖</span>
          <span class="label">Delete</span>
        </button>
      </div>
      
      <!-- Quit Button (bottom left) -->
      <button @click="quitServer" class="quit-btn" title="Quit Server">
        <span class="icon">✖</span>
        <span class="label">Quit</span>
      </button>
      
      <!-- Character List -->
      <div class="character-select-list">
        <h2 class="text-xl font-bold mb-4 text-white">Select Character</h2>
        
        <!-- Slots Full Message -->
        <div v-if="!canCreateMore" class="slots-full-message">
          <p>You have used up all character slots, please visit the server owners Tebex page to purchase more.</p>
        </div>
        
        <div class="character-select-row">
          <button
            @click="selectNew"
            :disabled="!canCreateMore"
            class="character-select-character new"
            :title="canCreateMore ? 'Create New Character' : `Maximum characters reached (${slots}/${slots})`"
          >
            <span class="icon">+</span>
            <span class="label">New</span>
          </button>
          
          <button
            v-for="char in characterStore.characters"
            :key="char.id"
            @click="selectCharacter(char)"
            :class="['character-select-character', { 'active': characterStore.selectedCharacter?.id === char.id }]"
            :title="char.name"
          >
            <span class="icon">👤</span>
            <span class="label">{{ char.name }}</span>
          </button>
        </div>
      </div>
    </div>
    
    <!-- Cancel Creation Confirmation Dialog -->
    <div v-if="showCancelConfirm && characterStore.isCreatingCharacter" class="confirmation-overlay">
      <div class="confirmation-dialog">
        <h3>Cancel Character Creation?</h3>
        <p>Are you sure you want to quit and return to character selection?</p>
        <div class="confirmation-actions">
          <button @click="confirmCancelCreate" class="btn-confirm-yes">Yes</button>
          <button @click="declineCancelCreate" class="btn-confirm-no">No</button>
        </div>
      </div>
    </div>
    
    <!-- Quit Confirmation Dialog -->
    <div v-if="showQuitConfirm" class="confirmation-overlay">
      <div class="confirmation-dialog">
        <h3>Leave Server?</h3>
        <p>Are you sure you want to leave this server?</p>
        <div class="confirmation-actions">
          <button @click="confirmQuit" class="btn-confirm-yes">Yes</button>
          <button @click="declineQuit" class="btn-confirm-no">No</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useCharacterStore } from '../stores/character'
import { useAppearanceStore } from '../stores/appearance'
import { sendNuiMessage } from '../utils/nui'

const characterStore = useCharacterStore()
const appearanceStore = useAppearanceStore()

const showCancelConfirm = ref(false)
const showQuitConfirm = ref(false)
const slots = ref(1)
const newCharacter = ref({
  firstName: '',
  lastName: ''
})

// Set slots from parent data (passed from Lua)
const setSlots = (slotCount) => {
  slots.value = slotCount || 1
}

// Check if player can create more characters
const canCreateMore = computed(() => {
  return characterStore.characters.length < slots.value
})

const availableSlots = computed(() => {
  return slots.value - characterStore.characters.length
})

function selectCharacter(char) {
  sendNuiMessage('NUI:Client:NewCharacter', { id: characterStore.selectedCharacter.id })
  characterStore.selectCharacter(char)
}

function selectNew() {
  if (!canCreateMore.value) {
    alert(`You have reached the maximum number of characters (${slots.value})`)
    return
  }
  
  // Trigger Lua event to start appearance customization
  // Do NOT show name form yet - wait for appearance customization to complete
  console.log('[CharacterSelect] Sending NUI:Client:NewCharacter')
  sendNuiMessage('NUI:Client:NewCharacter', {})
}

function cancelCreate() {
  console.log('[CharacterSelect] Cancel button clicked, showCancelConfirm before:', showCancelConfirm.value)
  showCancelConfirm.value = true
  console.log('[CharacterSelect] Cancel button clicked, showCancelConfirm after:', showCancelConfirm.value)
}

async function confirmCancelCreate() {
  showCancelConfirm.value = false
  
  try {
    // Hide/delete the ped on client
    await sendNuiMessage('NUI:Client:CancelCharacterCreation', {})
    
    // Reset form state
    newCharacter.value = { firstName: '', lastName: '' }
    
    // Reset appearance store
    appearanceStore.close()
    
    // Return to character selection
    characterStore.cancelCreatingCharacter()
  } catch (error) {
    console.error('[CharacterSelect] Error canceling character creation:', error)
    // Still return to character selection even on error
    characterStore.cancelCreatingCharacter()
  }
}

function declineCancelCreate() {
  showCancelConfirm.value = false
}

function quitServer() {
  showQuitConfirm.value = true
}

function confirmQuit() {
  showQuitConfirm.value = false
  sendNuiMessage('NUI:Client:QuitServer', {})
}

function declineQuit() {
  showQuitConfirm.value = false
}

function createCharacter() {
  const appearance = appearanceStore.getAppearance()
  
  console.log('[CharacterSelect] Sending NUI:Client:CharacterCreate with name and appearance')
  sendNuiMessage('NUI:Client:CharacterCreate', {
    firstName: newCharacter.value.firstName,
    lastName: newCharacter.value.lastName,
    appearance: appearance
  })
  newCharacter.value = { firstName: '', lastName: '' }
}

function playCharacter() {
  if (characterStore.selectedCharacter) {
    sendNuiMessage('NUI:Client:CharacterPlay', {
      id: characterStore.selectedCharacter.id
    })
  }
}

function deleteCharacter() {
  if (characterStore.selectedCharacter && confirm('Are you sure you want to delete this character?')) {
    sendNuiMessage('NUI:Client:CharacterDelete', {
      id: characterStore.selectedCharacter.id
    })
  }
}

function formatDate(dateString) {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleDateString()
}
</script>

<style scoped>
.character-select {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: linear-gradient(135deg, rgba(0, 0, 0, 0.9), rgba(20, 20, 20, 0.95));
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.character-select-main {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: auto auto;
  gap: 30px;
  padding: 40px;
  max-width: 1200px;
  width: 100%;
}

.character-select-info {
  grid-column: 1;
  grid-row: 1;
}

.character-select-options {
  grid-column: 2;
  grid-row: 1;
  display: flex;
  gap: 15px;
  align-items: flex-start;
}

.character-select-list {
  grid-column: 1 / -1;
  grid-row: 2;
}

.character-select-information {
  background: rgba(255, 255, 255, 0.05);
  padding: 25px;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.info-item {
  margin-bottom: 15px;
}

.info-item h3 {
  font-size: 14px;
  color: #9ca3af;
  margin-bottom: 4px;
}

.info-item p {
  font-size: 16px;
  color: white;
}

.option-btn {
  flex: 1;
  padding: 15px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.option-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.option-btn.play {
  border-color: #10b981;
}

.option-btn.play:hover {
  background: rgba(16, 185, 129, 0.2);
}

.option-btn.delete {
  border-color: #ef4444;
}

.option-btn.delete:hover {
  background: rgba(239, 68, 68, 0.2);
}

.option-btn .icon {
  font-size: 32px;
}

.option-btn .label {
  font-size: 14px;
  font-weight: 600;
}

.slots-full-message {
  background: rgba(239, 68, 68, 0.1);
  border: 1px solid rgba(239, 68, 68, 0.3);
  border-radius: 6px;
  padding: 16px;
  margin-bottom: 20px;
  color: #fca5a5;
  font-size: 14px;
  line-height: 1.5;
}

.character-select-row {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
}

.character-select-character {
  padding: 20px;
  background: rgba(255, 255, 255, 0.05);
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  min-width: 120px;
}

.character-select-character:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

.character-select-character.active {
  border-color: #3b82f6;
  background: rgba(59, 130, 246, 0.1);
}

.character-select-character.new {
  border-color: #10b981;
}

.character-select-character:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  border-color: rgba(255, 255, 255, 0.05);
}

.character-select-character:disabled:hover {
  background: rgba(255, 255, 255, 0.05);
  border-color: rgba(255, 255, 255, 0.05);
  transform: none;
}

.character-select-character .icon {
  font-size: 40px;
}

.character-select-character .label {
  font-size: 14px;
  font-weight: 600;
}

/* Character Creation Form */
.character-select-make {
  max-width: 500px;
  width: 100%;
}

.character-select-fieldset {
  background: rgba(255, 255, 255, 0.05);
  padding: 40px;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  font-size: 14px;
  color: #9ca3af;
  margin-bottom: 8px;
  font-weight: 600;
}

.form-group input {
  width: 100%;
  padding: 12px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 6px;
  color: white;
  font-size: 16px;
}

.form-group input:focus {
  outline: none;
  border-color: #3b82f6;
  background: rgba(255, 255, 255, 0.15);
}

.form-actions {
  display: flex;
  gap: 15px;
  margin-top: 30px;
}

.btn-create,
.btn-cancel {
  flex: 1;
  padding: 12px;
  border-radius: 6px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
}

.btn-create {
  background: #10b981;
  color: white;
}

.btn-create:hover {
  background: #059669;
}

.btn-cancel {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.btn-cancel:hover {
  background: rgba(255, 255, 255, 0.2);
}

/* Quit Button */
.quit-btn {
  position: fixed;
  bottom: 30px;
  left: 30px;
  padding: 15px 30px;
  background: rgba(255, 255, 255, 0.05);
  border: 2px solid rgba(239, 68, 68, 0.5);
  border-radius: 8px;
  color: rgba(239, 68, 68, 0.7);
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 10px;
  font-weight: 600;
  font-size: 16px;
  z-index: 100;
}

.quit-btn:hover {
  background: rgba(239, 68, 68, 0.9);
  border-color: rgba(239, 68, 68, 1);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
}

.quit-btn .icon {
  font-size: 20px;
}

/* Confirmation Dialog */
.confirmation-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.confirmation-dialog {
  background: rgba(30, 30, 30, 0.95);
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 40px;
  max-width: 500px;
  width: 90%;
  text-align: center;
}

.confirmation-dialog h3 {
  font-size: 24px;
  font-weight: 700;
  color: white;
  margin-bottom: 16px;
}

.confirmation-dialog p {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 30px;
  line-height: 1.5;
}

.confirmation-actions {
  display: flex;
  gap: 15px;
  justify-content: center;
}

.btn-confirm-yes,
.btn-confirm-no {
  padding: 12px 30px;
  border-radius: 6px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
  min-width: 100px;
}

.btn-confirm-yes {
  background: #ef4444;
  color: white;
}

.btn-confirm-yes:hover {
  background: #dc2626;
}

.btn-confirm-no {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.btn-confirm-no:hover {
  background: rgba(255, 255, 255, 0.2);
}
</style>
