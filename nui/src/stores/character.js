import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCharacterStore = defineStore('character', () => {
  const characters = ref([])
  const selectedCharacter = ref(null)
  const isCreatingCharacter = ref(false)
  const slots = ref(1)
  
  const isInCharacterSelect = computed(() => {
    return characters.value.length > 0 || isCreatingCharacter.value
  })
  
  function setCharacters(chars, slotCount) {
    characters.value = chars
    slots.value = slotCount || 1
    selectedCharacter.value = null
    isCreatingCharacter.value = false
  }
  
  function selectCharacter(char) {
    selectedCharacter.value = char
  }
  
  function startCreatingCharacter() {
    isCreatingCharacter.value = true
    selectedCharacter.value = null
  }
  
  function cancelCreatingCharacter() {
    isCreatingCharacter.value = false
  }
  
  return {
    characters,
    selectedCharacter,
    isCreatingCharacter,
    slots,
    isInCharacterSelect,
    setCharacters,
    selectCharacter,
    startCreatingCharacter,
    cancelCreatingCharacter
  }
})
