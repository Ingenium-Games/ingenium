<template>
  <div class="face-features-editor">
    <div
      v-for="feature in faceFeatures"
      :key="feature.id"
      class="feature-control"
    >
      <label>
        <span>{{ feature.name }}</span>
        <span class="value">{{ getCurrentValue(feature.id).toFixed(2) }}</span>
      </label>
      <input
        type="range"
        :value="getCurrentValue(feature.id)"
        @input="updateFeature(feature.id, $event.target.value)"
        :min="feature.min"
        :max="feature.max"
        step="0.01"
        class="slider"
        :aria-label="`${feature.name} slider`"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'

const appearanceStore = useAppearanceStore()

const faceFeatures = computed(() => {
  return appearanceStore.constants?.faceFeatures || []
})

const pendingUpdates = ref({})
const debounceTimers = ref({})

function getCurrentValue(featureId) {
  // Check pending updates first
  if (pendingUpdates.value[featureId] !== undefined) {
    return pendingUpdates.value[featureId]
  }
  
  const features = appearanceStore.currentAppearance?.faceFeatures || {}
  const storedValue = features[featureId] !== undefined ? features[featureId] : 0.0
  // Invert stored value for display (since we store it inverted)
  return storedValue * -1
}

function updateFeature(featureId, value) {
  // Invert the value because game engine has it backwards
  // User sees positive = increase, but game needs negative = increase
  const numValue = parseFloat(value) * -1
  
  // Store pending update (with original value for display)
  pendingUpdates.value[featureId] = parseFloat(value)
  
  // Clear existing timer
  if (debounceTimers.value[featureId]) {
    clearTimeout(debounceTimers.value[featureId])
  }
  
  // Set new timer
  debounceTimers.value[featureId] = setTimeout(() => {
    appearanceStore.updateFaceFeature(featureId, numValue)
    delete pendingUpdates.value[featureId]
    delete debounceTimers.value[featureId]
  }, 300)
}
</script>

<style scoped>
.face-features-editor {
  display: flex;
  flex-direction: column;
  gap: 16px;
  max-height: 550px;
  overflow-y: auto;
  padding-right: 8px;
}

.face-features-editor::-webkit-scrollbar {
  width: 6px;
}

.face-features-editor::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 3px;
}

.face-features-editor::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.face-features-editor::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.feature-control {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.feature-control label {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
}

.feature-control .value {
  color: #4287f5;
  font-weight: 600;
  font-size: 12px;
  min-width: 45px;
  text-align: right;
}

.slider {
  -webkit-appearance: none;
  appearance: none;
  width: 100%;
  height: 6px;
  background: rgba(42, 42, 42, 0.9);
  border-radius: 3px;
  outline: none;
  cursor: pointer;
}

.slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 16px;
  height: 16px;
  background: #4287f5;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s;
}

.slider::-webkit-slider-thumb:hover {
  transform: scale(1.2);
}

.slider::-moz-range-thumb {
  width: 16px;
  height: 16px;
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
