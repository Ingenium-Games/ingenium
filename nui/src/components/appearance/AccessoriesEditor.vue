<template>
  <div class="accessories-editor">
    <div
      v-for="prop in props"
      :key="prop.id"
      class="accessory-section"
    >
      <h4 class="prop-title">{{ prop.name }}</h4>
      
      <div class="prop-controls">
        <div class="control-row">
          <label>Drawable</label>
          <div class="input-with-buttons">
            <button @click="decrementDrawable(prop.id)" class="adj-btn" aria-label="Previous drawable">-</button>
            <input
              type="number"
              :value="getCurrentProp(prop.id).drawable"
              @input="updateDrawable(prop.id, $event.target.value)"
              min="-1"
              :max="getMaxDrawable(prop.id)"
              class="number-input"
              :aria-label="`${prop.name} drawable`"
            />
            <span class="max-label">/ {{ (propVariations[prop.id]?.drawableCount || 1) }}</span>
            <button @click="incrementDrawable(prop.id)" class="adj-btn" aria-label="Next drawable">+</button>
          </div>
          <span class="hint">-1 to remove</span>
        </div>
        
        <div class="control-row">
          <label>Texture</label>
          <div class="input-with-buttons">
            <button @click="decrementTexture(prop.id)" class="adj-btn" aria-label="Previous texture">-</button>
            <input
              type="number"
              :value="getCurrentProp(prop.id).texture"
              @input="updateTexture(prop.id, $event.target.value)"
              min="0"
              :max="getMaxTexture(prop.id)"
              class="number-input"
              :aria-label="`${prop.name} texture`"
            />
            <span class="max-label">/ {{ (propVariations[prop.id]?.textureCount || 1) }}</span>
            <button @click="incrementTexture(prop.id)" class="adj-btn" aria-label="Next texture">+</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'
import { callClientCallback } from '../../utils/nui'

const appearanceStore = useAppearanceStore()

// Track available variations for each prop
const propVariations = ref({})

const props = computed(() => {
  return appearanceStore.constants?.props || []
})

// Fetch variations when prop changes
async function refreshPropVariations(propId) {
  try {
    const result = await callClientCallback('Client:Appearance:GetPropVariations', propId)
    if (result.ok) {
      propVariations.value[propId] = {
        drawableCount: result.drawableCount,
        textureCount: result.textureCount,
        currentDrawable: result.currentDrawable,
        currentTexture: result.currentTexture
      }
    }
  } catch (error) {
    console.error(`Failed to get variations for prop ${propId}:`, error)
  }
}

// Get max values for validation (max index = count - 1)
function getMaxDrawable(propId) {
  const count = propVariations.value[propId]?.drawableCount
  return count ? count - 1 : 255
}

function getMaxTexture(propId) {
  const count = propVariations.value[propId]?.textureCount
  return count ? count - 1 : 255
}

function getCurrentProp(propId) {
  const propsList = appearanceStore.currentAppearance?.props || []
  const found = propsList.find(p => p.prop_id === propId)
  return found || { drawable: -1, texture: 0 }
}

async function updateDrawable(propId, value) {
  const current = getCurrentProp(propId)
  const maxDrawable = getMaxDrawable(propId)
  const drawable = Math.max(-1, Math.min(maxDrawable, parseInt(value) || -1))
  
  // Reset texture to 0 when drawable changes
  await appearanceStore.updateProp(propId, drawable, 0)
  // Refresh variations after drawable change (texture count may change)
  await refreshPropVariations(propId)
}

async function updateTexture(propId, value) {
  const current = getCurrentProp(propId)
  const maxTexture = getMaxTexture(propId)
  const texture = Math.max(0, Math.min(maxTexture, parseInt(value) || 0))
  await appearanceStore.updateProp(propId, current.drawable, texture)
}

async function incrementDrawable(propId) {
  const current = getCurrentProp(propId)
  const maxDrawable = getMaxDrawable(propId)
  const drawable = Math.min(maxDrawable, current.drawable + 1)
  
  // Reset texture to 0 when drawable changes
  await appearanceStore.updateProp(propId, drawable, 0)
  await refreshPropVariations(propId)
}

async function decrementDrawable(propId) {
  const current = getCurrentProp(propId)
  const drawable = Math.max(-1, current.drawable - 1)
  
  // Reset texture to 0 when drawable changes
  await appearanceStore.updateProp(propId, drawable, 0)
  await refreshPropVariations(propId)
}

async function incrementTexture(propId) {
  const current = getCurrentProp(propId)
  const maxTexture = getMaxTexture(propId)
  const texture = Math.min(maxTexture, current.texture + 1)
  await appearanceStore.updateProp(propId, current.drawable, texture)
}

async function decrementTexture(propId) {
  const current = getCurrentProp(propId)
  const texture = Math.max(0, current.texture - 1)
  await appearanceStore.updateProp(propId, current.drawable, texture)
}

// Load variations for all props when they become available
watch(props, async (newProps) => {
  if (newProps && newProps.length > 0) {
    for (const prop of newProps) {
      await refreshPropVariations(prop.id)
    }
  }
}, { immediate: true })
</script>

<style scoped>
.accessories-editor {
  display: flex;
  flex-direction: column;
  gap: 16px;
  max-height: 550px;
  overflow-y: auto;
  padding-right: 8px;
}

.accessories-editor::-webkit-scrollbar {
  width: 6px;
}

.accessories-editor::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 3px;
}

.accessories-editor::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.accessories-editor::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.accessory-section {
  padding: 10px;
  background: rgba(26, 26, 26, 0.5);
  border-radius: 6px;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.prop-title {
  font-size: 13px;
  font-weight: 600;
  color: white;
  margin: 0 0 10px 0;
}

.prop-controls {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.control-row {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.control-row label {
  font-size: 11px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
}

.hint {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.4);
  font-style: italic;
}

.input-with-buttons {
  display: flex;
  gap: 4px;
  align-items: center;
}

.adj-btn {
  width: 30px;
  height: 30px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 16px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.adj-btn:hover {
  background: rgba(58, 58, 58, 0.9);
  border-color: rgba(255, 255, 255, 0.2);
  color: white;
}

.adj-btn:active {
  transform: scale(0.95);
}

.number-input {
  flex: 1;
  padding: 6px 8px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  color: white;
  font-size: 13px;
  text-align: center;
  outline: none;
  transition: border-color 0.2s;
}

.number-input:focus {
  border-color: rgba(66, 135, 245, 0.5);
}

.number-input::-webkit-inner-spin-button,
.number-input::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
</style>
