<template>
  <div class="nui-container">
    <!-- Chat (always rendered for message display) -->
    <Chat />
    
    <!-- Character Select -->
    <CharacterSelect v-if="uiStore.showCharacterSelect" />
    
    <!-- HUD -->
    <HUD v-if="uiStore.showHUD" />
    
    <!-- Notifications -->
    <NotificationContainer />
    
    <!-- Input Dialog -->
    <InputDialog v-if="uiStore.showInput" />
    
    <!-- Menu -->
    <Menu v-if="uiStore.showMenu" />
    
    <!-- Context Menu -->
    <ContextMenu v-if="uiStore.showContextMenu" />
    
    <!-- Appearance Customization -->
    <AppearanceCustomization />
    
    <!-- Target Menu (integrated targeting system) -->
    <TargetMenu />
    
    <!-- Garage Menu (integrated garage system) -->
    <GarageMenu />
    
    <!-- Banking Menu -->
    <BankingMenu />
  </div>
</template>

<script setup>
import { onMounted, onUnmounted, watch } from 'vue'
import { useUIStore } from './stores/ui'
import { setupNuiHandlers, sendNuiMessage } from './utils/nui'
import Chat from './components/Chat.vue'
import CharacterSelect from './components/CharacterSelect.vue'
import HUD from './components/HUD.vue'
import NotificationContainer from './components/NotificationContainer.vue'
import InputDialog from './components/InputDialog.vue'
import Menu from './components/Menu.vue'
import ContextMenu from './components/ContextMenu.vue'
import AppearanceCustomization from './components/appearance/AppearanceCustomization.vue'
import TargetMenu from './components/target/TargetMenu.vue'
import GarageMenu from './components/GarageMenu.vue'
import BankingMenu from './components/BankingMenu.vue'

const uiStore = useUIStore()

// Watch for changes to critical UI state
watch(() => uiStore.showCharacterSelect, (newVal) => {
  console.log('[App.vue] uiStore.showCharacterSelect changed to:', newVal)
})

onMounted(() => {
  console.log('[App.vue] Mounted, setting up NUI handlers')
  console.log('[App.vue] uiStore.showCharacterSelect initial value:', uiStore.showCharacterSelect)
  setupNuiHandlers()
  
  // Request character data from server now that NUI is ready
  console.log('[App.vue] Requesting character data from server')
  sendNuiMessage('Client:Request:OnJoinGetCharactersFromServer')
})
</script>

<style scoped>
.nui-container {
  width: 100vw;
  height: 100vh;
  position: relative;
  pointer-events: none;
}

.nui-container > * {
  pointer-events: auto;
}
</style>
