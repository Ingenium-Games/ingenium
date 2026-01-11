import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useChatStore = defineStore('chat', () => {
  const isVisible = ref(false)
  const messages = ref([])
  const inputValue = ref('')
  const suggestions = ref([])
  const showSuggestions = ref(false)
  const maxMessages = 100

  function addMessage(message) {
    messages.value.push({
      id: Date.now() + Math.random(),
      author: message.author || 'System',
      text: message.text || '',
      color: message.color || [255, 255, 255],
      timestamp: Date.now(),
      args: message.args || []
    })

    // Keep only the last maxMessages
    if (messages.value.length > maxMessages) {
      messages.value.shift()
    }
  }

  function clearMessages() {
    messages.value = []
  }

  function show() {
    isVisible.value = true
  }

  function hide() {
    isVisible.value = false
    inputValue.value = ''
    showSuggestions.value = false
  }

  function setInputValue(value) {
    inputValue.value = value
    
    // Show suggestions if input starts with /
    if (value.startsWith('/')) {
      showSuggestions.value = true
    } else {
      showSuggestions.value = false
    }
  }

  function setSuggestions(newSuggestions) {
    suggestions.value = newSuggestions
  }

  function clearInput() {
    inputValue.value = ''
    showSuggestions.value = false
  }

  return {
    isVisible,
    messages,
    inputValue,
    suggestions,
    showSuggestions,
    addMessage,
    clearMessages,
    show,
    hide,
    setInputValue,
    setSuggestions,
    clearInput
  }
})
