import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { callClientCallback } from '../utils/nui'

export const useAppearanceStore = defineStore('appearance', () => {
  // State
  const isOpen = ref(false)
  const currentAppearance = ref(null)
  const constants = ref(null)
  const peds = ref(null)
  const tattoos = ref(null)
  const config = ref({})
  
  // Current tab
  const currentTab = ref('model')
  
  // Camera mode
  const cameraMode = ref('face')
  
  // Loading state
  const isLoading = ref(false)
  
  // Computed
  const isFreemode = computed(() => {
    if (!currentAppearance.value || !currentAppearance.value.model) return false
    const model = currentAppearance.value.model
    return model === 'mp_m_freemode_01' || model === 'mp_f_freemode_01'
  })
  
  const pedsByGender = computed(() => {
    if (!peds.value) return { male: [], female: [], unknown: [] }
    
    const result = { male: [], female: [], unknown: [] }
    for (const hash in peds.value) {
      const ped = peds.value[hash]
      if (ped.gender === 'male') result.male.push(ped)
      else if (ped.gender === 'female') result.female.push(ped)
      else result.unknown.push(ped)
    }
    
    return result
  })
  
  const tattoosByZone = computed(() => {
    if (!tattoos.value) return {}
    return tattoos.value
  })
  
  // Actions
  function open(data) {
    currentAppearance.value = data.appearance
    constants.value = data.constants
    peds.value = data.peds
    tattoos.value = data.tattoos
    config.value = data.config || {}
    isOpen.value = true
    currentTab.value = data.config?.allowModelChange !== false ? 'model' : 'heritage'
  }
  
  function close() {
    isOpen.value = false
    currentAppearance.value = null
    constants.value = null
    peds.value = null
    tattoos.value = null
    config.value = {}
    currentTab.value = 'model'
  }
  
  function setTab(tab) {
    currentTab.value = tab
  }
  
  function setCameraMode(mode) {
    cameraMode.value = mode
    callClientCallback('Client:Appearance:SetCameraView', mode)
  }
  
  async function updateModel(model) {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:UpdateModel', model)
      currentAppearance.value.model = model
    } finally {
      isLoading.value = false
    }
  }
  
  async function updateHeadBlend(headBlend) {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:UpdateHeadBlend', headBlend)
      currentAppearance.value.headBlend = { ...headBlend }
    } finally {
      isLoading.value = false
    }
  }
  
  async function updateFaceFeature(index, value) {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:UpdateFaceFeature', index, value)
      if (!currentAppearance.value.faceFeatures) {
        currentAppearance.value.faceFeatures = {}
      }
      currentAppearance.value.faceFeatures[index] = value
    } finally {
      isLoading.value = false
    }
  }
  
  async function updateHeadOverlay(overlayId, data) {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:UpdateHeadOverlay', overlayId, data)
      if (!currentAppearance.value.headOverlays) {
        currentAppearance.value.headOverlays = {}
      }
      currentAppearance.value.headOverlays[overlayId] = { ...data }
    } finally {
      isLoading.value = false
    }
  }
  
  async function updateHair(hair) {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:UpdateHair', hair)
      currentAppearance.value.hair = { ...hair }
    } finally {
      isLoading.value = false
    }
  }
  
  async function updateEyeColor(color) {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:UpdateEyeColor', color)
      currentAppearance.value.eyeColor = color
    } finally {
      isLoading.value = false
    }
  }
  
  async function updateComponent(componentId, drawable, texture) {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:UpdateComponent', componentId, drawable, texture)
      if (!currentAppearance.value.components) {
        currentAppearance.value.components = []
      }
      const index = currentAppearance.value.components.findIndex(c => c.component_id === componentId)
      if (index >= 0) {
        currentAppearance.value.components[index] = { component_id: componentId, drawable, texture }
      } else {
        currentAppearance.value.components.push({ component_id: componentId, drawable, texture })
      }
    } finally {
      isLoading.value = false
    }
  }
  
  async function updateProp(propId, drawable, texture) {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:UpdateProp', propId, drawable, texture)
      if (!currentAppearance.value.props) {
        currentAppearance.value.props = []
      }
      const index = currentAppearance.value.props.findIndex(p => p.prop_id === propId)
      if (index >= 0) {
        currentAppearance.value.props[index] = { prop_id: propId, drawable, texture }
      } else {
        currentAppearance.value.props.push({ prop_id: propId, drawable, texture })
      }
    } finally {
      isLoading.value = false
    }
  }
  
  async function applyTattoo(collection, hash) {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:ApplyTattoo', collection, hash)
      if (!currentAppearance.value.tattoos) {
        currentAppearance.value.tattoos = []
      }
      // Check if tattoo already exists
      const exists = currentAppearance.value.tattoos.some(t => t.collection === collection && t.hash === hash)
      if (!exists) {
        currentAppearance.value.tattoos.push({ collection, hash })
      }
    } finally {
      isLoading.value = false
    }
  }
  
  async function removeTattoo(collection, hash) {
    isLoading.value = true
    try {
      if (currentAppearance.value.tattoos) {
        currentAppearance.value.tattoos = currentAppearance.value.tattoos.filter(
          t => !(t.collection === collection && t.hash === hash)
        )
        // Reapply all remaining tattoos
        await callClientCallback('Client:Appearance:ClearTattoos')
        for (const tattoo of currentAppearance.value.tattoos) {
          await callClientCallback('Client:Appearance:ApplyTattoo', tattoo.collection, tattoo.hash)
        }
      }
    } finally {
      isLoading.value = false
    }
  }
  
  async function clearAllTattoos() {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:ClearTattoos')
      currentAppearance.value.tattoos = []
    } finally {
      isLoading.value = false
    }
  }
  
  async function rotateCamera(degrees) {
    await callClientCallback('Client:Appearance:RotateCamera', degrees)
  }
  
  async function turnAround(duration = 2000) {
    await callClientCallback('Client:Appearance:TurnAround', duration)
  }
  
  async function save() {
    isLoading.value = true
    try {
      await callClientCallback('Client:Appearance:Save')
      
      // If this was character creation, trigger registration
      if (config.value.isCharacterCreation) {
        // Character creation will be handled by the NUI
        // The appearance is already saved, now show registration form
        close()
      } else {
        close()
      }
    } finally {
      isLoading.value = false
    }
  }
  
  async function cancel() {
    await callClientCallback('Client:Appearance:Cancel')
    close()
  }
  
  return {
    // State
    isOpen,
    currentAppearance,
    constants,
    peds,
    tattoos,
    config,
    currentTab,
    cameraMode,
    isLoading,
    
    // Computed
    isFreemode,
    pedsByGender,
    tattoosByZone,
    
    // Actions
    open,
    close,
    setTab,
    setCameraMode,
    updateModel,
    updateHeadBlend,
    updateFaceFeature,
    updateHeadOverlay,
    updateHair,
    updateEyeColor,
    updateComponent,
    updateProp,
    applyTattoo,
    removeTattoo,
    clearAllTattoos,
    rotateCamera,
    turnAround,
    save,
    cancel
  }
})
