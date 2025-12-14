import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCharacterStore = defineStore('character', () => {
  const characters = ref([])
  const selectedCharacter = ref(null)
  const isCreatingCharacter = ref(false)
  
  const isInCharacterSelect = computed(() => {
    return characters.value.length > 0 || isCreatingCharacter.value
  })
  
  function setCharacters(chars) {
    characters.value = chars
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
    isInCharacterSelect,
    setCharacters,
    selectCharacter,
    startCreatingCharacter,
    cancelCreatingCharacter
  }
})
