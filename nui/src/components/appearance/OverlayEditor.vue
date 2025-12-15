<template>
  <div class="overlay-editor">
    <div
      v-for="overlay in headOverlays"
      :key="overlay.id"
      class="overlay-section"
    >
      <h4 class="overlay-title">{{ overlay.name }}</h4>
      
      <div class="overlay-controls">
        <div class="control-row">
          <label>Style</label>
          <select
            :value="getCurrentOverlay(overlay.id).style"
            @change="updateOverlayStyle(overlay.id, $event.target.value)"
            class="overlay-select"
            :aria-label="`${overlay.name} style`"
          >
            <option value="0">None</option>
            <option v-for="i in overlay.maxStyle + 1" :key="i" :value="i">{{ i }}</option>
          </select>
        </div>
        
        <div class="control-row">
          <label>
            <span>Opacity</span>
            <span class="value">{{ (getCurrentOverlay(overlay.id).opacity * 100).toFixed(0) }}%</span>
          </label>
          <input
            type="range"
            :value="getCurrentOverlay(overlay.id).opacity"
            @input="updateOverlayOpacity(overlay.id, $event.target.value)"
            min="0"
            max="1"
            step="0.01"
            class="slider"
            :aria-label="`${overlay.name} opacity`"
          />
        </div>
        
        <div v-if="overlay.hasColor" class="control-row">
          <label>Color</label>
          <select
            :value="getCurrentOverlay(overlay.id).color"
            @change="updateOverlayColor(overlay.id, $event.target.value)"
            class="overlay-select"
            :aria-label="`${overlay.name} color`"
          >
            <option v-for="i in 64" :key="i-1" :value="i-1">Color {{ i-1 }}</option>
          </select>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'

const appearanceStore = useAppearanceStore()

const headOverlays = computed(() => {
  return appearanceStore.constants?.headOverlays || []
})

function getCurrentOverlay(overlayId) {
  const overlays = appearanceStore.currentAppearance?.headOverlays || {}
  return overlays[overlayId] || { style: 0, opacity: 0.0, color: 0 }
}

function updateOverlayStyle(overlayId, style) {
  const current = getCurrentOverlay(overlayId)
  appearanceStore.updateHeadOverlay(overlayId, {
    ...current,
    style: parseInt(style)
  })
}

function updateOverlayOpacity(overlayId, opacity) {
  const current = getCurrentOverlay(overlayId)
  appearanceStore.updateHeadOverlay(overlayId, {
    ...current,
    opacity: parseFloat(opacity)
  })
}

function updateOverlayColor(overlayId, color) {
  const current = getCurrentOverlay(overlayId)
  appearanceStore.updateHeadOverlay(overlayId, {
    ...current,
    color: parseInt(color)
  })
}
</script>

<style scoped>
.overlay-editor {
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-height: 550px;
  overflow-y: auto;
  padding-right: 8px;
}

.overlay-editor::-webkit-scrollbar {
  width: 6px;
}

.overlay-editor::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 3px;
}

.overlay-editor::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.overlay-editor::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.overlay-section {
  padding: 12px;
  background: rgba(26, 26, 26, 0.5);
  border-radius: 6px;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.overlay-title {
  font-size: 14px;
  font-weight: 600;
  color: white;
  margin: 0 0 12px 0;
}

.overlay-controls {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.control-row {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.control-row label {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
}

.control-row .value {
  color: #4287f5;
  font-weight: 600;
}

.overlay-select {
  padding: 6px 10px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  color: white;
  font-size: 13px;
  cursor: pointer;
  outline: none;
  transition: border-color 0.2s;
}

.overlay-select:hover {
  border-color: rgba(255, 255, 255, 0.2);
}

.overlay-select:focus {
  border-color: rgba(66, 135, 245, 0.5);
}

.slider {
  -webkit-appearance: none;
  appearance: none;
  width: 100%;
  height: 5px;
  background: rgba(42, 42, 42, 0.9);
  border-radius: 3px;
  outline: none;
  cursor: pointer;
}

.slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 14px;
  height: 14px;
  background: #4287f5;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s;
}

.slider::-webkit-slider-thumb:hover {
  transform: scale(1.2);
}

.slider::-moz-range-thumb {
  width: 14px;
  height: 14px;
  background: #4287f5;
  border-radius: 50%;
  cursor: pointer;
  border: none;
  transition: all 0.2s;
}

.slider::-moz-range-thumb:hover {
  transform: scale(1.2);
}
</style>
