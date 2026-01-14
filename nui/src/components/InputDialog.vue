<template>
  <div class="input-overlay" @click.self="closeInput">
    <div class="input-container">
      <div class="input-header">
        <h2>{{ uiStore.inputData.title }}</h2>
        <button @click="closeInput" class="close-btn">✖</button>
      </div>
      
      <form @submit.prevent="submitInput" class="input-form">
        <input
          ref="inputField"
          v-model="inputValue"
          type="text"
          :placeholder="uiStore.inputData.placeholder"
          :maxlength="uiStore.inputData.maxLength || 100"
          class="input-field"
          autofocus
        />
        
        <div class="input-actions">
          <button type="submit" class="btn-submit">Submit</button>
          <button type="button" @click="closeInput" class="btn-cancel">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useUIStore } from '../stores/ui'
import { sendNuiMessage } from '../utils/nui'

const uiStore = useUIStore()
const inputValue = ref('')
const inputField = ref(null)

onMounted(() => {
  nextTick(() => {
    if (inputField.value) {
      inputField.value.focus()
    }
  })
})

function submitInput() {
  sendNuiMessage('NUI:Client:InputSubmit', { value: inputValue.value })
  inputValue.value = ''
  uiStore.showInput = false
}

function closeInput() {
  uiStore.showInput = false
  inputValue.value = ''
  sendNuiMessage('NUI:Client:InputClose')
}
</script>

<style scoped>
.input-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.input-container {
  background: linear-gradient(135deg, rgba(26, 26, 26, 0.98), rgba(42, 42, 42, 0.98));
  border-radius: 12px;
  min-width: 400px;
  max-width: 600px;
  overflow: hidden;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.input-header {
  padding: 20px 25px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.input-header h2 {
  font-size: 20px;
  font-weight: 700;
  color: white;
  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  color: white;
  font-size: 20px;
  cursor: pointer;
  opacity: 0.7;
  transition: opacity 0.3s;
  padding: 5px;
}

.close-btn:hover {
  opacity: 1;
}

.input-form {
  padding: 25px;
}

.input-field {
  width: 100%;
  padding: 12px 15px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  color: white;
  font-size: 16px;
  margin-bottom: 20px;
}

.input-field:focus {
  outline: none;
  border-color: #3b82f6;
  background: rgba(255, 255, 255, 0.15);
}

.input-field::placeholder {
  color: #9ca3af;
}

.input-actions {
  display: flex;
  gap: 10px;
}

.btn-submit,
.btn-cancel {
  flex: 1;
  padding: 12px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
}

.btn-submit {
  background: #3b82f6;
  color: white;
}

.btn-submit:hover {
  background: #2563eb;
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
