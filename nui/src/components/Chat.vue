<template>
  <div v-if="chatStore.isVisible || chatStore.messages.length > 0" class="chat-container">
    <!-- Messages Display -->
    <div class="chat-messages" ref="messagesContainer">
      <div
        v-for="message in visibleMessages"
        :key="message.id"
        class="chat-message"
        :style="{ color: `rgb(${message.color[0]}, ${message.color[1]}, ${message.color[2]})` }"
      >
        <span v-if="message.author" class="chat-author">{{ message.author }}:</span>
        <span class="chat-text">{{ message.text }}</span>
      </div>
    </div>

    <!-- Input Field (only visible when chat is active) -->
    <div v-if="chatStore.isVisible" class="chat-input-container">
      <input
        ref="chatInput"
        v-model="chatStore.inputValue"
        @keydown.enter="sendMessage"
        @keydown.esc="closeChat"
        @input="onInputChange"
        type="text"
        class="chat-input"
        placeholder="Enter a message or command..."
        maxlength="256"
        autofocus
      />
      
      <!-- Command Suggestions -->
      <div v-if="chatStore.showSuggestions && filteredSuggestions.length > 0" class="chat-suggestions">
        <div
          v-for="(suggestion, index) in filteredSuggestions"
          :key="index"
          class="chat-suggestion"
        >
          <div class="suggestion-name">{{ suggestion.name }}</div>
          <div v-if="suggestion.help" class="suggestion-help">{{ suggestion.help }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, nextTick, onMounted, onUnmounted } from 'vue'
import { useChatStore } from '../stores/chat'
import { sendNuiMessage } from '../utils/nui'

const chatStore = useChatStore()
const messagesContainer = ref(null)
const chatInput = ref(null)
const forceUpdate = ref(0)

// Get resource name for NUI callbacks with validation
let resourceName = 'ingenium' // Safe fallback
if (window.GetParentResourceName) {
  const name = window.GetParentResourceName()
  // Validate resource name (alphanumeric, dots, underscores, hyphens only)
  if (name && /^[a-zA-Z0-9._-]+$/.test(name)) {
    resourceName = name
  }
}

// Show messages from the last 10 seconds, or all messages if chat is visible
const visibleMessages = computed(() => {
  // Force reactivity update
  forceUpdate.value
  
  if (chatStore.isVisible) {
    return chatStore.messages
  }
  
  const now = Date.now()
  const visibilityTime = 10000 // 10 seconds
  
  return chatStore.messages.filter(msg => {
    return (now - msg.timestamp) < visibilityTime
  })
})

// Clean up old messages every second to trigger fade-out
let cleanupInterval = null
onMounted(() => {
  cleanupInterval = setInterval(() => {
    if (!chatStore.isVisible && chatStore.messages.length > 0) {
      const now = Date.now()
      const visibilityTime = 10000
      
      // Remove messages older than 10 seconds
      chatStore.messages = chatStore.messages.filter(msg => {
        return (now - msg.timestamp) < visibilityTime
      })
      
      // Force computed to re-evaluate
      forceUpdate.value++
    }
  }, 1000) // Check every second
})

onUnmounted(() => {
  if (cleanupInterval) {
    clearInterval(cleanupInterval)
  }
})

// Filter suggestions based on input
const filteredSuggestions = computed(() => {
  if (!chatStore.inputValue.startsWith('/')) {
    return []
  }
  
  const command = chatStore.inputValue.slice(1).toLowerCase()
  
  if (!command) {
    return chatStore.suggestions.slice(0, 5) // Show first 5 suggestions
  }
  
  return chatStore.suggestions
    .filter(s => s.name.toLowerCase().startsWith(command))
    .slice(0, 5)
})

// Auto-scroll to bottom when new messages arrive
watch(() => chatStore.messages.length, async () => {
  await nextTick()
  if (messagesContainer.value) {
    messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
  }
})

// Focus input when chat becomes visible
watch(() => chatStore.isVisible, async (isVisible) => {
  if (isVisible) {
    await nextTick()
    if (chatInput.value) {
      chatInput.value.focus()
    }
  }
})

function onInputChange(event) {
  chatStore.setInputValue(event.target.value)
}

function sendMessage() {
  if (!chatStore.inputValue.trim()) {
    closeChat()
    return
  }
  
  // Send message to Lua
  fetch(`https://${resourceName}/NUI:Client:ChatSubmit`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      message: chatStore.inputValue
    })
  })
  
  chatStore.clearInput()
  closeChat()
}

function closeChat() {
  fetch(`https://${resourceName}/NUI:Client:ChatClose`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({})
  })
  
  chatStore.hide()
}
</script>

<style scoped>
.chat-container {
  position: fixed;
  bottom: 20px;
  left: 20px;
  width: 500px;
  max-width: 90vw;
  pointer-events: none;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  z-index: 10000; /* Above all other UI elements */
}

.chat-messages {
  max-height: 300px;
  overflow-y: auto;
  padding: 10px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  pointer-events: none;
}

.chat-messages::-webkit-scrollbar {
  width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.3);
  border-radius: 3px;
}

.chat-messages::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
}

.chat-message {
  font-size: 14px;
  line-height: 1.4;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.8);
  word-wrap: break-word;
  animation: fadeIn 0.3s ease-in;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.chat-author {
  font-weight: bold;
  margin-right: 4px;
}

.chat-text {
  color: rgba(255, 255, 255, 0.95);
}

.chat-input-container {
  margin-top: 8px;
  pointer-events: auto;
}

.chat-input {
  width: 100%;
  padding: 10px 12px;
  font-size: 14px;
  background: rgba(0, 0, 0, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  color: white;
  outline: none;
  transition: all 0.2s;
}

.chat-input:focus {
  background: rgba(0, 0, 0, 0.8);
  border-color: rgba(255, 255, 255, 0.4);
}

.chat-input::placeholder {
  color: rgba(255, 255, 255, 0.4);
}

.chat-suggestions {
  margin-top: 8px;
  background: rgba(0, 0, 0, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  padding: 8px;
  max-height: 200px;
  overflow-y: auto;
}

.chat-suggestion {
  padding: 6px 8px;
  cursor: pointer;
  border-radius: 3px;
  transition: background 0.2s;
}

.chat-suggestion:hover {
  background: rgba(255, 255, 255, 0.1);
}

.suggestion-name {
  font-weight: bold;
  color: #4CAF50;
  font-size: 13px;
}

.suggestion-help {
  color: rgba(255, 255, 255, 0.6);
  font-size: 12px;
  margin-top: 2px;
}
</style>
