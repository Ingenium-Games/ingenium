<template>
  <div class="heritage-editor">
    <div class="heritage-section">
      <h3 class="section-title">Face</h3>
      <div class="parent-selectors">
        <div class="parent-selector">
          <label>Mother</label>
          <select
            :value="headBlend.shapeFirst"
            @change="updateShapeFirst($event.target.value)"
            class="parent-select"
            aria-label="Select mother"
          >
            <option v-for="i in MAX_PARENT_HEADS" :key="i-1" :value="i-1">{{ i-1 }}</option>
          </select>
        </div>
        
        <div class="parent-selector">
          <label>Father</label>
          <select
            :value="headBlend.shapeSecond"
            @change="updateShapeSecond($event.target.value)"
            class="parent-select"
            aria-label="Select father"
          >
            <option v-for="i in MAX_PARENT_HEADS" :key="i-1" :value="i-1">{{ i-1 }}</option>
          </select>
        </div>
      </div>
      
      <div class="slider-control">
        <label>
          <span>Face Mix</span>
          <span class="value">{{ (headBlend.shapeMix * 100).toFixed(0) }}%</span>
        </label>
        <input
          type="range"
          :value="headBlend.shapeMix"
          @input="updateShapeMix($event.target.value)"
          min="0"
          max="1"
          step="0.01"
          class="slider"
          aria-label="Face mix slider"
        />
      </div>
    </div>
    
    <div class="heritage-section">
      <h3 class="section-title">Skin</h3>
      <div class="parent-selectors">
        <div class="parent-selector">
          <label>Mother</label>
          <select
            :value="headBlend.skinFirst"
            @change="updateSkinFirst($event.target.value)"
            class="parent-select"
            aria-label="Select mother skin"
          >
            <option v-for="i in MAX_PARENT_HEADS" :key="i-1" :value="i-1">{{ i-1 }}</option>
          </select>
        </div>
        
        <div class="parent-selector">
          <label>Father</label>
          <select
            :value="headBlend.skinSecond"
            @change="updateSkinSecond($event.target.value)"
            class="parent-select"
            aria-label="Select father skin"
          >
            <option v-for="i in MAX_PARENT_HEADS" :key="i-1" :value="i-1">{{ i-1 }}</option>
          </select>
        </div>
      </div>
      
      <div class="slider-control">
        <label>
          <span>Skin Mix</span>
          <span class="value">{{ (headBlend.skinMix * 100).toFixed(0) }}%</span>
        </label>
        <input
          type="range"
          :value="headBlend.skinMix"
          @input="updateSkinMix($event.target.value)"
          min="0"
          max="1"
          step="0.01"
          class="slider"
          aria-label="Skin mix slider"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'

const appearanceStore = useAppearanceStore()

const MAX_PARENT_HEADS = 46

const headBlend = computed(() => {
  return appearanceStore.currentAppearance?.headBlend || {
    shapeFirst: 0,
    shapeSecond: 0,
    skinFirst: 0,
    skinSecond: 0,
    shapeMix: 0.5,
    skinMix: 0.5,
    thirdMix: 0.0
  }
})

function updateShapeFirst(value) {
  appearanceStore.updateHeadBlend({
    ...headBlend.value,
    shapeFirst: parseInt(value)
  })
}

function updateShapeSecond(value) {
  appearanceStore.updateHeadBlend({
    ...headBlend.value,
    shapeSecond: parseInt(value)
  })
}

function updateShapeMix(value) {
  appearanceStore.updateHeadBlend({
    ...headBlend.value,
    shapeMix: parseFloat(value)
  })
}

function updateSkinFirst(value) {
  appearanceStore.updateHeadBlend({
    ...headBlend.value,
    skinFirst: parseInt(value)
  })
}

function updateSkinSecond(value) {
  appearanceStore.updateHeadBlend({
    ...headBlend.value,
    skinSecond: parseInt(value)
  })
}

function updateSkinMix(value) {
  appearanceStore.updateHeadBlend({
    ...headBlend.value,
    skinMix: parseFloat(value)
  })
}
</script>

<style scoped>
.heritage-editor {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.heritage-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: white;
  margin: 0;
}

.parent-selectors {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.parent-selector {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.parent-selector label {
  font-size: 13px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
}

.parent-select {
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

.parent-select:hover {
  border-color: rgba(255, 255, 255, 0.2);
}

.parent-select:focus {
  border-color: rgba(66, 135, 245, 0.5);
}

.slider-control {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.slider-control label {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
}

.slider-control .value {
  color: #4287f5;
  font-weight: 600;
  font-size: 12px;
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
