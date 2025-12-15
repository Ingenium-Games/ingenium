<template>
  <div class="hair-editor">
    <div class="section">
      <h3 class="section-title">Hair Style</h3>
      <div class="style-grid">
        <button
          v-for="i in 73"
          :key="i-1"
          @click="updateHairStyle(i-1)"
          :class="['style-btn', { active: currentHair.style === (i-1) }]"
          :aria-label="`Hair style ${i-1}`"
        >
          {{ i-1 }}
        </button>
      </div>
    </div>
    
    <div class="section">
      <h3 class="section-title">Hair Color</h3>
      <div class="color-selectors">
        <div class="color-selector">
          <label>Primary</label>
          <select
            :value="currentHair.color"
            @change="updateHairColor($event.target.value)"
            class="color-select"
            aria-label="Primary hair color"
          >
            <option v-for="i in hairColorCount" :key="i-1" :value="i-1">Color {{ i-1 }}</option>
          </select>
        </div>
        
        <div class="color-selector">
          <label>Highlight</label>
          <select
            :value="currentHair.highlight"
            @change="updateHairHighlight($event.target.value)"
            class="color-select"
            aria-label="Hair highlight color"
          >
            <option v-for="i in hairColorCount" :key="i-1" :value="i-1">Color {{ i-1 }}</option>
          </select>
        </div>
      </div>
    </div>
    
    <div class="section">
      <h3 class="section-title">Eye Color</h3>
      <div class="eye-color-grid">
        <button
          v-for="color in eyeColors"
          :key="color.id"
          @click="updateEyeColor(color.id)"
          :class="['eye-color-btn', { active: currentEyeColor === color.id }]"
          :style="{ background: color.color }"
          :aria-label="`Eye color: ${color.name}`"
          :title="color.name"
        >
          <span v-if="currentEyeColor === color.id" class="checkmark">✓</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'

const appearanceStore = useAppearanceStore()

const hairColorCount = 64

const currentHair = computed(() => {
  return appearanceStore.currentAppearance?.hair || {
    style: 0,
    color: 0,
    highlight: 0
  }
})

const currentEyeColor = computed(() => {
  return appearanceStore.currentAppearance?.eyeColor ?? 0
})

const eyeColors = computed(() => {
  return appearanceStore.constants?.eyeColors || []
})

function updateHairStyle(style) {
  appearanceStore.updateHair({
    ...currentHair.value,
    style
  })
}

function updateHairColor(color) {
  appearanceStore.updateHair({
    ...currentHair.value,
    color: parseInt(color)
  })
}

function updateHairHighlight(highlight) {
  appearanceStore.updateHair({
    ...currentHair.value,
    highlight: parseInt(highlight)
  })
}

function updateEyeColor(color) {
  appearanceStore.updateEyeColor(color)
}
</script>

<style scoped>
.hair-editor {
  display: flex;
  flex-direction: column;
  gap: 24px;
  max-height: 550px;
  overflow-y: auto;
  padding-right: 8px;
}

.hair-editor::-webkit-scrollbar {
  width: 6px;
}

.hair-editor::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 3px;
}

.hair-editor::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.hair-editor::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.section {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: white;
  margin: 0;
}

.style-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(45px, 1fr));
  gap: 6px;
}

.style-btn {
  padding: 8px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 12px;
  cursor: pointer;
  transition: all 0.2s;
}

.style-btn:hover {
  background: rgba(58, 58, 58, 0.9);
  border-color: rgba(255, 255, 255, 0.2);
  color: white;
}

.style-btn.active {
  background: rgba(66, 135, 245, 0.2);
  border-color: rgba(66, 135, 245, 0.6);
  color: #4287f5;
}

.color-selectors {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.color-selector {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.color-selector label {
  font-size: 13px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
}

.color-select {
  padding: 8px 12px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  color: white;
  font-size: 14px;
  cursor: pointer;
  outline: none;
  transition: border-color 0.2s;
}

.color-select:hover {
  border-color: rgba(255, 255, 255, 0.2);
}

.color-select:focus {
  border-color: rgba(66, 135, 245, 0.5);
}

.eye-color-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(35px, 1fr));
  gap: 6px;
}

.eye-color-btn {
  width: 100%;
  aspect-ratio: 1;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: bold;
  text-shadow: 0 0 3px rgba(0, 0, 0, 0.8);
}

.eye-color-btn:hover {
  transform: scale(1.1);
  border-color: rgba(255, 255, 255, 0.4);
}

.eye-color-btn.active {
  border-color: white;
  border-width: 3px;
}

.checkmark {
  font-size: 16px;
}
</style>
