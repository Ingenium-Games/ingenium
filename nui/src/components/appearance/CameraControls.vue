<template>
  <div class="camera-controls">
    <div class="camera-views">
      <button
        v-for="view in views"
        :key="view.value"
        @click="setView(view.value)"
        :class="['view-btn', { active: appearanceStore.cameraMode === view.value }]"
        :aria-label="`Camera view: ${view.label}`"
        :title="view.label"
      >
        {{ view.label }}
      </button>
    </div>
    
    <div class="camera-actions">
      <button
        @click="rotate(-30)"
        class="action-btn"
        aria-label="Rotate left"
        title="Rotate Left"
      >
        ←
      </button>
      <button
        @click="turnAround"
        class="action-btn"
        aria-label="Turn around"
        title="Turn Around"
      >
        ↻
      </button>
      <button
        @click="rotate(30)"
        class="action-btn"
        aria-label="Rotate right"
        title="Rotate Right"
      >
        →
      </button>
    </div>
  </div>
</template>

<script setup>
import { useAppearanceStore } from '../../stores/appearance'
import { callClientCallback } from '../../utils/nui'

const appearanceStore = useAppearanceStore()

const views = [
  { value: 'face', label: 'Face' },
  { value: 'body', label: 'Body' },
  { value: 'legs', label: 'Legs' },
  { value: 'feet', label: 'Feet' },
  { value: 'full', label: 'Full' }
]

async function setView(view) {
  appearanceStore.setCameraMode(view)
  await callClientCallback('Client:Appearance:SetCameraView', { view })
}

async function rotate(degrees) {
  const direction = degrees < 0 ? 'left' : 'right'
  await callClientCallback('Client:Appearance:RotatePed', { direction })
}

async function turnAround() {
  await callClientCallback('Client:Appearance:RotatePed', { direction: 'reset' })
}
</script>

<style scoped>
.camera-controls {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.camera-views {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.view-btn {
  padding: 8px 16px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  flex: 1;
  min-width: 60px;
}

.view-btn:hover {
  background: rgba(58, 58, 58, 0.9);
  border-color: rgba(255, 255, 255, 0.2);
  color: rgba(255, 255, 255, 0.9);
}

.view-btn.active {
  background: rgba(66, 135, 245, 0.2);
  border-color: rgba(66, 135, 245, 0.5);
  color: #4287f5;
}

.camera-actions {
  display: flex;
  gap: 8px;
  justify-content: center;
}

.action-btn {
  padding: 10px 20px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 18px;
  cursor: pointer;
  transition: all 0.2s;
  min-width: 50px;
}

.action-btn:hover {
  background: rgba(58, 58, 58, 0.9);
  border-color: rgba(255, 255, 255, 0.2);
  color: rgba(255, 255, 255, 0.9);
  transform: scale(1.05);
}

.action-btn:active {
  transform: scale(0.95);
}
</style>
