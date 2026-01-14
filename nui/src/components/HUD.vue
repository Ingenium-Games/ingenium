<template>
  <div 
    class="hud-container"
    :style="{ 
      left: position.x + 'px', 
      top: position.y + 'px',
      zIndex: hudZIndex
    }"
    :class="{ 'hud-focused': isFocused }"
  >
    <div 
      class="hud-stats" 
      @mousedown="startDrag"
      :title="isFocused ? 'Drag to reposition HUD' : 'Press F2 to enable drag mode'"
    >
      <!-- Health -->
      <div class="hud-stat">
        <span class="hud-stat-label">Health</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill health" :style="{ width: `${uiStore.hudData.health}%` }"></div>
        </div>
      </div>
      
      <!-- Armor -->
      <div class="hud-stat" v-if="uiStore.hudData.armor > 0">
        <span class="hud-stat-label">Armor</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill armor" :style="{ width: `${uiStore.hudData.armor}%` }"></div>
        </div>
      </div>
      
      <!-- Hunger -->
      <div class="hud-stat">
        <span class="hud-stat-label">Hunger</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill hunger" :style="{ width: `${uiStore.hudData.hunger}%` }"></div>
        </div>
      </div>
      
      <!-- Thirst -->
      <div class="hud-stat">
        <span class="hud-stat-label">Thirst</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill thirst" :style="{ width: `${uiStore.hudData.thirst}%` }"></div>
        </div>
      </div>
      
      <!-- Stress -->
      <div class="hud-stat">
        <span class="hud-stat-label">Stress</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill stress" :style="{ width: `${uiStore.hudData.stress}%` }"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useUIStore } from '../stores/ui'

const uiStore = useUIStore()
const position = ref({ x: 20, y: window.innerHeight - 120 })
const isDragging = ref(false)
const dragStart = ref({ x: 0, y: 0 })
const isFocused = ref(false)

// Compute z-index based on focus state
const hudZIndex = computed(() => 
  isFocused.value ? 1001 : 100
)

onMounted(() => {
  const savedPos = localStorage.getItem('hud_position')
  if (savedPos) {
    try {
      position.value = JSON.parse(savedPos)
    } catch (e) {
      console.error('Failed to parse HUD position:', e)
    }
  }
  
  // Listen for HUD focus toggle messages from Lua
  window.addEventListener('message', handleHudMessage)
})

onUnmounted(() => {
  window.removeEventListener('message', handleHudMessage)
})

function handleHudMessage(event) {
  const { message, data } = event.data
  
  if (message === 'Client:NUI:HUDFocus') {
    isFocused.value = data.focused
  } else if (message === 'Client:NUI:HUDResetPosition') {
    position.value = { x: 20, y: window.innerHeight - 120 }
    localStorage.setItem('hud_position', JSON.stringify(position.value))
  } else if (message === 'Client:NUI:HUDSetPosition') {
    position.value = data.position
    localStorage.setItem('hud_position', JSON.stringify(position.value))
  }
}

function startDrag(e) {
  // Only allow dragging when HUD is focused
  if (!isFocused.value) return
  
  isDragging.value = true
  dragStart.value = { x: e.clientX - position.value.x, y: e.clientY - position.value.y }
  document.addEventListener('mousemove', handleDrag)
  document.addEventListener('mouseup', stopDrag)
}

function handleDrag(e) {
  if (isDragging.value) {
    position.value.x = e.clientX - dragStart.value.x
    position.value.y = e.clientY - dragStart.value.y
  }
}

function stopDrag() {
  isDragging.value = false
  localStorage.setItem('hud_position', JSON.stringify(position.value))
  document.removeEventListener('mousemove', handleDrag)
  document.removeEventListener('mouseup', stopDrag)
}

onUnmounted(() => {
  document.removeEventListener('mousemove', handleDrag)
  document.removeEventListener('mouseup', stopDrag)
})
</script>

<style scoped>
.hud-container {
  position: fixed;
  display: flex;
  flex-direction: column;
  gap: 15px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  z-index: 100;
  transition: border 0.2s ease;
}

.hud-container.hud-focused {
  border: 2px solid #4CAF50;
  border-radius: 4px;
  box-shadow: 0 0 10px rgba(76, 175, 80, 0.3);
}

.hud-stats {
  display: flex;
  flex-direction: column;
  gap: 8px;
  cursor: grab;
  user-select: none;
  padding: 10px;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 4px;
  transition: background-color 0.2s, cursor 0.2s;
}

.hud-container.hud-focused .hud-stats {
  cursor: grabbing;
  background: rgba(0, 0, 0, 0.5);
}

.hud-stats:hover {
  background: rgba(0, 0, 0, 0.5);
}

.hud-stat {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.hud-stat-label {
  color: white;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.8);
}

.hud-stat-bar {
  width: 200px;
  height: 8px;
  background-color: rgba(0, 0, 0, 0.5);
  border-radius: 4px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
}

.hud-stat-fill {
  height: 100%;
  transition: width 0.3s ease;
}

.hud-stat-fill.health {
  background: linear-gradient(90deg, #dc2626, #ef4444);
}

.hud-stat-fill.armor {
  background: linear-gradient(90deg, #2563eb, #3b82f6);
}

.hud-stat-fill.hunger {
  background: linear-gradient(90deg, #ea580c, #f97316);
}

.hud-stat-fill.thirst {
  background: linear-gradient(90deg, #0891b2, #06b6d4);
}

.hud-stat-fill.stress {
  background: linear-gradient(90deg, #7c3aed, #a855f7);
}
</style>
