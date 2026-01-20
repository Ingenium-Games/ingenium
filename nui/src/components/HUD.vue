<template>
  <!-- Individual draggable HUD elements -->
  <div class="hud-elements">
    <!-- Health -->
    <div 
      class="hud-stat-container"
      :style="{ 
        left: positions.health.x + 'px', 
        top: positions.health.y + 'px',
        zIndex: dragging === 'health' ? 1001 : 100
      }"
      :class="{ 'hud-focused': uiStore.hudFocused }"
      @mousedown="(e) => startDrag(e, 'health')"
      :title="uiStore.hudFocused ? 'Drag to reposition Health' : 'Press F2 to enable drag mode'"
    >
      <div class="hud-stat">
        <span class="hud-stat-label">Health</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill health" :style="{ width: `${uiStore.hudData.health}%` }"></div>
        </div>
      </div>
    </div>

    <!-- Armor -->
    <div 
      v-if="uiStore.hudData.armor > 0"
      class="hud-stat-container"
      :style="{ 
        left: positions.armor.x + 'px', 
        top: positions.armor.y + 'px',
        zIndex: dragging === 'armor' ? 1001 : 100
      }"
      :class="{ 'hud-focused': uiStore.hudFocused }"
      @mousedown="(e) => startDrag(e, 'armor')"
      :title="uiStore.hudFocused ? 'Drag to reposition Armor' : 'Press F2 to enable drag mode'"
    >
      <div class="hud-stat">
        <span class="hud-stat-label">Armor</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill armor" :style="{ width: `${uiStore.hudData.armor}%` }"></div>
        </div>
      </div>
    </div>

    <!-- Hunger -->
    <div 
      class="hud-stat-container"
      :style="{ 
        left: positions.hunger.x + 'px', 
        top: positions.hunger.y + 'px',
        zIndex: dragging === 'hunger' ? 1001 : 100
      }"
      :class="{ 'hud-focused': uiStore.hudFocused }"
      @mousedown="(e) => startDrag(e, 'hunger')"
      :title="uiStore.hudFocused ? 'Drag to reposition Hunger' : 'Press F2 to enable drag mode'"
    >
      <div class="hud-stat">
        <span class="hud-stat-label">Hunger</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill hunger" :style="{ width: `${uiStore.hudData.hunger}%` }"></div>
        </div>
      </div>
    </div>

    <!-- Thirst -->
    <div 
      class="hud-stat-container"
      :style="{ 
        left: positions.thirst.x + 'px', 
        top: positions.thirst.y + 'px',
        zIndex: dragging === 'thirst' ? 1001 : 100
      }"
      :class="{ 'hud-focused': uiStore.hudFocused }"
      @mousedown="(e) => startDrag(e, 'thirst')"
      :title="uiStore.hudFocused ? 'Drag to reposition Thirst' : 'Press F2 to enable drag mode'"
    >
      <div class="hud-stat">
        <span class="hud-stat-label">Thirst</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill thirst" :style="{ width: `${uiStore.hudData.thirst}%` }"></div>
        </div>
      </div>
    </div>

    <!-- Stress -->
    <div 
      class="hud-stat-container"
      :style="{ 
        left: positions.stress.x + 'px', 
        top: positions.stress.y + 'px',
        zIndex: dragging === 'stress' ? 1001 : 100
      }"
      :class="{ 'hud-focused': uiStore.hudFocused }"
      @mousedown="(e) => startDrag(e, 'stress')"
      :title="uiStore.hudFocused ? 'Drag to reposition Stress' : 'Press F2 to enable drag mode'"
    >
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
import { ref, onMounted, onUnmounted } from 'vue'
import { useUIStore } from '../stores/ui'

const uiStore = useUIStore()

// Default positions for each stat (stacked vertically on left side)
const defaultPositions = {
  health: { x: 20, y: window.innerHeight - 200 },
  armor: { x: 20, y: window.innerHeight - 160 },
  hunger: { x: 20, y: window.innerHeight - 120 },
  thirst: { x: 20, y: window.innerHeight - 80 },
  stress: { x: 20, y: window.innerHeight - 40 }
}

const positions = ref({ ...defaultPositions })
const dragging = ref(null)
const dragStart = ref({ x: 0, y: 0 })

onMounted(() => {
  // Load saved positions
  const savedPositions = localStorage.getItem('hud_stat_positions')
  if (savedPositions) {
    try {
      const parsed = JSON.parse(savedPositions)
      positions.value = { ...defaultPositions, ...parsed }
    } catch (e) {
      console.error('Failed to parse HUD stat positions:', e)
    }
  }
  
  window.addEventListener('message', handleHudMessage)
})

onUnmounted(() => {
  window.removeEventListener('message', handleHudMessage)
  stopDrag()
})

function handleHudMessage(event) {
  const { message, data } = event.data
  
  if (message === 'Client:NUI:HUDResetPosition') {
    positions.value = { ...defaultPositions }
    localStorage.setItem('hud_stat_positions', JSON.stringify(positions.value))
  }
}

function startDrag(e, statName) {
  if (!uiStore.hudFocused) return
  
  e.preventDefault()
  dragging.value = statName
  dragStart.value = { 
    x: e.clientX - positions.value[statName].x, 
    y: e.clientY - positions.value[statName].y 
  }
  
  document.addEventListener('mousemove', handleDrag)
  document.addEventListener('mouseup', stopDrag)
}

function handleDrag(e) {
  if (dragging.value) {
    positions.value[dragging.value] = {
      x: e.clientX - dragStart.value.x,
      y: e.clientY - dragStart.value.y
    }
  }
}

function stopDrag() {
  if (dragging.value) {
    // Save positions when drag ends
    localStorage.setItem('hud_stat_positions', JSON.stringify(positions.value))
  }
  dragging.value = null
  document.removeEventListener('mousemove', handleDrag)
  document.removeEventListener('mouseup', stopDrag)
}
</script>

<style scoped>
.hud-elements {
  pointer-events: none;
}

.hud-stat-container {
  position: fixed;
  pointer-events: none; /* Default: clicks pass through */
}

.hud-stat-container.hud-focused {
  pointer-events: auto; /* Enable interaction when focused */
  pointer-events: auto;
  transition: border 0.2s ease, box-shadow 0.2s ease;
}

.hud-stat-container.hud-focused {
  pointer-events: auto; /* Enable interaction when focused */
  cursor: grab;
}

.hud-stat-container.hud-focused:hover {
  border: 2px solid rgba(76, 175, 80, 0.5);
  border-radius: 6px;
  box-shadow: 0 0 10px rgba(76, 175, 80, 0.3);
}

.hud-stat-container.hud-focused:active {
  cursor: grabbing;
  border-color: #4CAF50;
  box-shadow: 0 0 15px rgba(76, 175, 80, 0.5);
}

.hud-stat {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 8px 10px;
  background: rgba(0, 0, 0, 0.4);
  border-radius: 4px;
  user-select: none;
  transition: background-color 0.2s;
}

.hud-focused .hud-stat:hover {
  background: rgba(0, 0, 0, 0.6);
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
