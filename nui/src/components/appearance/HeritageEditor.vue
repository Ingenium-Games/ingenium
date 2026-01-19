<template>
  <div class="heritage-editor">
    <div class="heritage-section">
      <h3 class="section-title">Face</h3>
      <div class="parent-selectors">
        <div class="parent-selector">
          <label>Mother</label>
          <div class="gender-toggle">
            <button 
              :class="['toggle-btn', { active: motherFaceGender === 'female' }]"
              @click="motherFaceGender = 'female'"
            >
              Female
            </button>
            <button 
              :class="['toggle-btn', { active: motherFaceGender === 'male' }]"
              @click="motherFaceGender = 'male'"
            >
              Male
            </button>
          </div>
          <select
            :value="headBlend.shapeFirst"
            @change="updateShapeFirst($event.target.value)"
            class="parent-select"
            aria-label="Select mother"
          >
            <option v-for="faceId in motherFaceList" :key="faceId" :value="faceId">{{ faceId }}</option>
          </select>
        </div>
        
        <div class="parent-selector">
          <label>Father</label>
          <div class="gender-toggle">
            <button 
              :class="['toggle-btn', { active: fatherFaceGender === 'male' }]"
              @click="fatherFaceGender = 'male'"
            >
              Male
            </button>
            <button 
              :class="['toggle-btn', { active: fatherFaceGender === 'female' }]"
              @click="fatherFaceGender = 'female'"
            >
              Female
            </button>
          </div>
          <select
            :value="headBlend.shapeSecond"
            @change="updateShapeSecond($event.target.value)"
            class="parent-select"
            aria-label="Select father"
          >
            <option v-for="faceId in fatherFaceList" :key="faceId" :value="faceId">{{ faceId }}</option>
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
          <div class="gender-toggle">
            <button 
              :class="['toggle-btn', { active: motherSkinGender === 'female' }]"
              @click="motherSkinGender = 'female'"
            >
              Female
            </button>
            <button 
              :class="['toggle-btn', { active: motherSkinGender === 'male' }]"
              @click="motherSkinGender = 'male'"
            >
              Male
            </button>
          </div>
          <select
            :value="headBlend.skinFirst"
            @change="updateSkinFirst($event.target.value)"
            class="parent-select"
            aria-label="Select mother skin"
          >
            <option v-for="faceId in motherSkinList" :key="faceId" :value="faceId">{{ faceId }}</option>
          </select>
        </div>
        
        <div class="parent-selector">
          <label>Father</label>
          <div class="gender-toggle">
            <button 
              :class="['toggle-btn', { active: fatherSkinGender === 'male' }]"
              @click="fatherSkinGender = 'male'"
            >
              Male
            </button>
            <button 
              :class="['toggle-btn', { active: fatherSkinGender === 'female' }]"
              @click="fatherSkinGender = 'female'"
            >
              Female
            </button>
          </div>
          <select
            :value="headBlend.skinSecond"
            @change="updateSkinSecond($event.target.value)"
            class="parent-select"
            aria-label="Select father skin"
          >
            <option v-for="faceId in fatherSkinList" :key="faceId" :value="faceId">{{ faceId }}</option>
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
import { computed, ref, watch, onMounted, nextTick } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'

const appearanceStore = useAppearanceStore()

// Gender toggles for face and skin heritage
const motherFaceGender = ref('female')
const fatherFaceGender = ref('male')
const motherSkinGender = ref('female')
const fatherSkinGender = ref('male')

// Get heritage face lists from constants
const heritageFaces = computed(() => {
  return appearanceStore.constants?.heritageFaces || { male: [], female: [] }
})

// Computed lists based on gender selection
const motherFaceList = computed(() => {
  return heritageFaces.value[motherFaceGender.value] || []
})

const fatherFaceList = computed(() => {
  return heritageFaces.value[fatherFaceGender.value] || []
})

const motherSkinList = computed(() => {
  return heritageFaces.value[motherSkinGender.value] || []
})

const fatherSkinList = computed(() => {
  return heritageFaces.value[fatherSkinGender.value] || []
})

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

// Watch gender changes and default to first face in list
watch(motherFaceGender, (newGender) => {
  const list = heritageFaces.value[newGender] || []
  if (list.length > 0) {
    updateShapeFirst(list[0])
  }
})

watch(fatherFaceGender, (newGender) => {
  const list = heritageFaces.value[newGender] || []
  if (list.length > 0) {
    updateShapeSecond(list[0])
  }
})

watch(motherSkinGender, (newGender) => {
  const list = heritageFaces.value[newGender] || []
  if (list.length > 0) {
    updateSkinFirst(list[0])
  }
})

watch(fatherSkinGender, (newGender) => {
  const list = heritageFaces.value[newGender] || []
  if (list.length > 0) {
    updateSkinSecond(list[0])
  }
})

// Watch for when appearance store opens - initialize heritage defaults
watch(() => appearanceStore.isOpen, (isOpen) => {
  if (isOpen) {
    nextTick(() => {
      // Check if this is a freemode ped that needs heritage
      const model = appearanceStore.currentAppearance?.model
      const isFreemode = model === 'mp_m_freemode_01' || model === 'mp_f_freemode_01'
      
      if (isFreemode) {
        const femaleList = heritageFaces.value['female'] || []
        const maleList = heritageFaces.value['male'] || []
        
        console.log('[HeritageEditor] Store opened with freemode ped, initializing heritage')
        console.log('[HeritageEditor] Female list:', femaleList.length, 'Male list:', maleList.length)
        console.log('[HeritageEditor] Current headBlend:', JSON.stringify(headBlend.value))
        
        if (femaleList.length > 0 && maleList.length > 0) {
          // Check if heritage needs initialization (all values are 0 or undefined)
          const needsInit = !headBlend.value.shapeFirst && !headBlend.value.shapeSecond &&
                           !headBlend.value.skinFirst && !headBlend.value.skinSecond
          
          if (needsInit) {
            console.log('[HeritageEditor] Initializing all heritage defaults')
            
            // Set gender toggles
            motherFaceGender.value = 'female'
            fatherFaceGender.value = 'male'
            motherSkinGender.value = 'female'
            fatherSkinGender.value = 'male'
            
            // Set all 4 heritage values
            appearanceStore.updateHeadBlend({
              shapeFirst: femaleList[0],    // Mother face
              shapeSecond: maleList[0],     // Father face
              skinFirst: femaleList[0],     // Mother skin
              skinSecond: maleList[0],      // Father skin
              shapeMix: 0.5,
              skinMix: 0.5,
              thirdMix: 0.0
            })
          }
        }
      }
    })
  }
})

// Watch model changes - reset to defaults when switching to freemode
watch(() => appearanceStore.currentAppearance?.model, (newModel, oldModel) => {
  // Check if the new model is freemode
  const isNewFreemode = newModel === 'mp_m_freemode_01' || newModel === 'mp_f_freemode_01'
  
  // Reset heritage to defaults whenever switching TO a freemode ped
  // This ensures clean slate when changing models
  if (isNewFreemode) {
    console.log('[HeritageEditor] Model changed to freemode, resetting all heritage fields to defaults')
    
    const femaleList = heritageFaces.value['female'] || []
    const maleList = heritageFaces.value['male'] || []
    
    if (femaleList.length > 0 && maleList.length > 0) {
      // FIRST: Reset gender toggles to defaults
      motherFaceGender.value = 'female'
      fatherFaceGender.value = 'male'
      motherSkinGender.value = 'female'
      fatherSkinGender.value = 'male'
      
      // THEN: Update all heritage values in one go
      nextTick(() => {
        console.log('[HeritageEditor] Setting heritage - Mother Face:', femaleList[0], 'Father Face:', maleList[0])
        console.log('[HeritageEditor] Setting heritage - Mother Skin:', femaleList[0], 'Father Skin:', maleList[0])
        
        // Update all 4 values at once using the store's updateHeadBlend
        appearanceStore.updateHeadBlend({
          shapeFirst: femaleList[0],    // Mother face - first female
          shapeSecond: maleList[0],      // Father face - first male
          skinFirst: femaleList[0],      // Mother skin - first female
          skinSecond: maleList[0],       // Father skin - first male
          shapeMix: 0.5,                 // 50% blend
          skinMix: 0.5,                  // 50% blend
          thirdMix: 0.0                  // No third parent
        })
      })
    }
  }
})

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

.gender-toggle {
  display: flex;
  gap: 4px;
  margin-bottom: 4px;
}

.toggle-btn {
  flex: 1;
  padding: 6px 8px;
  background: rgba(42, 42, 42, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  color: rgba(255, 255, 255, 0.6);
  font-size: 11px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.toggle-btn:hover {
  background: rgba(42, 42, 42, 0.9);
  border-color: rgba(255, 255, 255, 0.2);
  color: rgba(255, 255, 255, 0.8);
}

.toggle-btn.active {
  background: rgba(66, 135, 245, 0.3);
  border-color: rgba(66, 135, 245, 0.6);
  color: #4287f5;
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

