<template>
  <div class="menu-overlay" @click.self="closeMenu">
    <div class="menu-container">
      <div class="menu-header">
        <h2>{{ uiStore.menuData.title }}</h2>
        <button @click="closeMenu" class="close-btn">✖</button>
      </div>
      
      <div class="menu-items">
        <button
          v-for="(item, index) in uiStore.menuData.items"
          :key="index"
          @click="selectItem(item)"
          :class="['menu-item', { disabled: item.disabled }]"
          :disabled="item.disabled"
        >
          <span class="menu-item-label">{{ item.label }}</span>
          <span v-if="item.description" class="menu-item-description">{{ item.description }}</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useUIStore } from '../stores/ui'
import { sendNuiMessage } from '../utils/nui'

const uiStore = useUIStore()

function selectItem(item) {
  if (!item.disabled) {
    sendNuiMessage('menu:select', { action: item.action, data: item.data })
    closeMenu()
  }
}

function closeMenu() {
  uiStore.showMenu = false
  sendNuiMessage('menu:close')
}
</script>

<style scoped>
.menu-overlay {
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

.menu-container {
  background: linear-gradient(135deg, rgba(26, 26, 26, 0.98), rgba(42, 42, 42, 0.98));
  border-radius: 12px;
  min-width: 400px;
  max-width: 600px;
  max-height: 80vh;
  overflow: hidden;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.menu-header {
  padding: 20px 25px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.menu-header h2 {
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

.menu-items {
  padding: 10px;
  max-height: calc(80vh - 80px);
  overflow-y: auto;
}

.menu-item {
  width: 100%;
  padding: 15px 20px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-bottom: 8px;
  text-align: left;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.menu-item:hover:not(.disabled) {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateX(5px);
}

.menu-item.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.menu-item-label {
  font-size: 16px;
  font-weight: 600;
}

.menu-item-description {
  font-size: 13px;
  color: #9ca3af;
}
</style>
