<template>
  <div class="clothing-editor">
    <div
      v-for="component in components"
      :key="component.id"
      class="clothing-section"
    >
      <div class="component-header">
        <h4 class="component-title">{{ component.name }}</h4>
        <span v-if="showPricing && getComponentPrice(component.id) > 0" class="component-price">
          ${{ getComponentPrice(component.id) }}
        </span>
      </div>
      
      <div class="component-controls">
        <div class="control-row">
          <label>Drawable</label>
          <div class="input-with-buttons">
            <button @click="decrementDrawable(component.id)" class="adj-btn" aria-label="Previous drawable">-</button>
            <input
              type="number"
              :value="getCurrentComponent(component.id).drawable"
              @input="updateDrawable(component.id, $event.target.value)"
              min="0"
              :max="getMaxDrawable(component.id)"
              class="number-input"
              :aria-label="`${component.name} drawable`"
            />
            <span class="max-label">/ {{ getMaxDrawable(component.id) }}</span>
            <button @click="incrementDrawable(component.id)" class="adj-btn" aria-label="Next drawable">+</button>
          </div>
        </div>
        
        <div class="control-row">
          <label>Texture</label>
          <div class="input-with-buttons">
            <button @click="decrementTexture(component.id)" class="adj-btn" aria-label="Previous texture">-</button>
            <input
              type="number"
              :value="getCurrentComponent(component.id).texture"
              @input="updateTexture(component.id, $event.target.value)"
              min="0"
              :max="getMaxTexture(component.id)"
              class="number-input"
              :aria-label="`${component.name} texture`"
            />
            <span class="max-label">/ {{ getMaxTexture(component.id) }}</span>
            <button @click="incrementTexture(component.id)" class="adj-btn" aria-label="Next texture">+</button>
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

// Track available variations for each component
const componentVariations = ref({})

const components = computed(() => {
  return appearanceStore.constants?.components || []
})

const showPricing = computed(() => {
  return appearanceStore.pricingEnabled && 
         appearanceStore.pricing?.pricing?.clothing?.enabled
})

// Fetch variations when component changes
async function refreshComponentVariations(componentId) {
  try {
    const result = await callClientCallback('Client:Appearance:GetComponentVariations', componentId)
    if (result.ok) {
      componentVariations.value[componentId] = {
        drawableCount: result.drawableCount,
        textureCount: result.textureCount,
        currentDrawable: result.currentDrawable,
        currentTexture: result.currentTexture
      }
    }
  } catch (error) {
    console.error(`Failed to get variations for component ${componentId}:`, error)
  }
}

// Get max values for validation
function getMaxDrawable(componentId) {
  return componentVariations.value[componentId]?.drawableCount - 1 || 255
}

function getMaxTexture(componentId) {
  return componentVariations.value[componentId]?.textureCount - 1 || 255
}

function getComponentPrice(componentId) {
  if (!showPricing.value) return 0
  return appearanceStore.getItemPrice('clothing', componentId)
}

function getCurrentComponent(componentId) {
  const comps = appearanceStore.currentAppearance?.components || []
  const found = comps.find(c => c.component_id === componentId)
  return found || { drawable: 0, texture: 0 }
}

async function updateDrawable(componentId, value) {
  const current = getCurrentComponent(componentId)
  const maxDrawable = getMaxDrawable(componentId)
  const drawable = Math.max(0, Math.min(maxDrawable, parseInt(value) || 0))
  await appearanceStore.updateComponent(componentId, drawable, current.texture)
  // Refresh variations after drawable change (texture count may change)
  await refreshComponentVariations(componentId)
}

async function updateTexture(componentId, value) {
  const current = getCurrentComponent(componentId)
  const maxTexture = getMaxTexture(componentId)
  const texture = Math.max(0, Math.min(maxTexture, parseInt(value) || 0))
  await appearanceStore.updateComponent(componentId, current.drawable, texture)
}

async function incrementDrawable(componentId) {
  const current = getCurrentComponent(componentId)
  const maxDrawable = getMaxDrawable(componentId)
  const drawable = Math.min(maxDrawable, current.drawable + 1)
  await appearanceStore.updateComponent(componentId, drawable, current.texture)
  await refreshComponentVariations(componentId)
}

async function decrementDrawable(componentId) {
  const current = getCurrentComponent(componentId)
  const drawable = Math.max(0, current.drawable - 1)
  await appearanceStore.updateComponent(componentId, drawable, current.texture)
  await refreshComponentVariations(componentId)
}

async function incrementTexture(componentId) {
  const current = getCurrentComponent(componentId)
  const maxTexture = getMaxTexture(componentId)
  const texture = Math.min(maxTexture, current.texture + 1)
  await appearanceStore.updateComponent(componentId, current.drawable, texture)
}

async function decrementTexture(componentId) {
  const current = getCurrentComponent(componentId)
  const texture = Math.max(0, current.texture - 1)
  await appearanceStore.updateComponent(componentId, current.drawable, texture)
}

// Load variations for all components when they become available
watch(components, async (newComponents) => {
  if (newComponents && newComponents.length > 0) {
    for (const component of newComponents) {
      await refreshComponentVariations(component.id)
    }
  }
}, { immediate: true })
</script>

<style scoped>
.clothing-editor {
  display: flex;
  flex-direction: column;
  gap: 16px;
  max-height: 550px;
  overflow-y: auto;
  padding-right: 8px;
}

.clothing-editor::-webkit-scrollbar {
  width: 6px;
}

.clothing-editor::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 3px;
}

.clothing-editor::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.clothing-editor::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.clothing-section {
  padding: 10px;
  background: rgba(26, 26, 26, 0.5);
  border-radius: 6px;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.component-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.component-title {
  font-size: 13px;
  font-weight: 600;
  color: white;
  margin: 0;
}

.component-price {
  font-size: 11px;
  font-weight: 700;
  color: #4287f5;
  padding: 3px 8px;
  background: rgba(66, 135, 245, 0.1);
  border-radius: 4px;
  border: 1px solid rgba(66, 135, 245, 0.3);
}

.component-controls {
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

.input-with-buttons {
  display: flex;
  gap: 4px;
  align-items: center;
}

.max-label {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.5);
  min-width: 40px;
  text-align: center;
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
