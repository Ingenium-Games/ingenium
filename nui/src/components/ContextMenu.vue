<template>
  <div 
    class="context-menu"
    :style="{ top: `${uiStore.contextMenuData.position.y}px`, left: `${uiStore.contextMenuData.position.x}px` }"
  >
    <div class="context-menu-header" v-if="uiStore.contextMenuData.title">
      {{ uiStore.contextMenuData.title }}
    </div>
    
    <div class="context-menu-items">
      <button
        v-for="(item, index) in uiStore.contextMenuData.items"
        :key="index"
        @click="selectItem(item)"
        :class="['context-menu-item', { disabled: item.disabled }]"
        :disabled="item.disabled"
      >
        <span class="context-menu-icon" v-if="item.icon">{{ item.icon }}</span>
        <span class="context-menu-label">{{ item.label }}</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { useUIStore } from '../stores/ui'
import { sendNuiMessage } from '../utils/nui'

const uiStore = useUIStore()

function selectItem(item) {
  if (!item.disabled) {
    sendNuiMessage('NUI:Client:ContextSelect', { action: item.action, data: item.data })
    closeContextMenu()
  }
}

function closeContextMenu() {
  uiStore.showContextMenu = false
  sendNuiMessage('NUI:Client:ContextClose')
}
</script>

<style scoped>
.context-menu {
  position: fixed;
  background: linear-gradient(135deg, rgba(26, 26, 26, 0.98), rgba(42, 42, 42, 0.98));
  border-radius: 8px;
  min-width: 200px;
  max-width: 300px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  z-index: 2000;
}

.context-menu-header {
  padding: 12px 15px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  font-size: 14px;
  font-weight: 700;
  color: white;
  text-transform: uppercase;
}

.context-menu-items {
  padding: 5px;
}

.context-menu-item {
  width: 100%;
  padding: 10px 15px;
  background: transparent;
  border: none;
  color: white;
  cursor: pointer;
  transition: all 0.2s ease;
  text-align: left;
  display: flex;
  align-items: center;
  gap: 10px;
  border-radius: 6px;
  font-size: 14px;
}

.context-menu-item:hover:not(.disabled) {
  background: rgba(255, 255, 255, 0.1);
}

.context-menu-item.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.context-menu-icon {
  font-size: 16px;
  width: 20px;
  text-align: center;
}

.context-menu-label {
  flex: 1;
}
</style>
