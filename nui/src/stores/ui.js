import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUIStore = defineStore('ui', () => {
  // UI visibility states
  const showHUD = ref(false)
  const showCharacterSelect = ref(false)
  const showMenu = ref(false)
  const showInput = ref(false)
  const showContextMenu = ref(false)
  
  // HUD data
  const hudData = ref({
    health: 100,
    armor: 0,
    hunger: 100,
    thirst: 100,
    stress: 0,
    cash: 0,
    bank: 0,
    job: '',
    jobGrade: ''
  })
  
  // Menu data
  const menuData = ref({
    title: '',
    items: []
  })
  
  // Input data
  const inputData = ref({
    title: '',
    placeholder: '',
    maxLength: 100
  })
  
  // Context menu data
  const contextMenuData = ref({
    title: '',
    items: [],
    position: { x: 0, y: 0 }
  })
  
  // Actions
  function updateHUD(data) {
    hudData.value = { ...hudData.value, ...data }
  }
  
  function openMenu(data) {
    menuData.value = data
    showMenu.value = true
  }
  
  function openInput(data) {
    inputData.value = data
    showInput.value = true
  }
  
  function openContextMenu(data) {
    contextMenuData.value = data
    showContextMenu.value = true
  }
  
  function closeAll() {
    showMenu.value = false
    showInput.value = false
    showContextMenu.value = false
  }
  
  return {
    // State
    showHUD,
    showCharacterSelect,
    showMenu,
    showInput,
    showContextMenu,
    hudData,
    menuData,
    inputData,
    contextMenuData,
    
    // Actions
    updateHUD,
    openMenu,
    openInput,
    openContextMenu,
    closeAll
  }
})
