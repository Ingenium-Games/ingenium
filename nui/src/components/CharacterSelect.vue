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
            <button type="button" @click="cancelCreate" class="btn-cancel">Cancel</button>
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
      
      <!-- Character List -->
      <div class="character-select-list">
        <h2 class="text-xl font-bold mb-4 text-white">Select Character</h2>
        <div class="character-select-row">
          <button
            @click="selectNew"
            class="character-select-character new"
            title="Create New Character"
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
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useCharacterStore } from '../stores/character'
import { sendNuiMessage } from '../utils/nui'

const characterStore = useCharacterStore()
const newCharacter = ref({
  firstName: '',
  lastName: ''
})

function selectCharacter(char) {
  characterStore.selectCharacter(char)
}

function selectNew() {
  characterStore.startCreatingCharacter()
}

function cancelCreate() {
  characterStore.cancelCreatingCharacter()
}

function createCharacter() {
  sendNuiMessage('character:create', {
    firstName: newCharacter.value.firstName,
    lastName: newCharacter.value.lastName
  })
  newCharacter.value = { firstName: '', lastName: '' }
}

function playCharacter() {
  if (characterStore.selectedCharacter) {
    sendNuiMessage('character:play', {
      id: characterStore.selectedCharacter.id
    })
  }
}

function deleteCharacter() {
  if (characterStore.selectedCharacter && confirm('Are you sure you want to delete this character?')) {
    sendNuiMessage('character:delete', {
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
</style>
