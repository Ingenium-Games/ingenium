import { defineStore } from 'pinia'
import { ref, computed, watch } from 'vue'
import { callClientCallback } from '../utils/nui'

export const useAppearanceStore = defineStore('appearance', () => {
  // State
  const isOpen = ref(false)
  const currentAppearance = ref(null)
  const constants = ref(null)
  const peds = ref(null)
  const tattoos = ref(null)
  const config = ref({})
  const pricing = ref(null)
  
  // Pricing state
  const initialAppearance = ref(null)
  const currentCost = ref(0)
  const itemizedCosts = ref([])
  const showCostConfirmation = ref(false)
  
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
  
  const pricingEnabled = computed(() => {
    return pricing.value && pricing.value.pricing && pricing.value.pricing.enabled
  })
  
  // Actions
  function open(data) {
    console.log('[AppearanceStore] Opening with data:', data)
    console.log('[AppearanceStore] - appearance:', data.appearance)
    console.log('[AppearanceStore] - constants:', data.constants)
    console.log('[AppearanceStore] - peds type:', typeof data.peds, 'is array:', Array.isArray(data.peds))
    console.log('[AppearanceStore] - peds keys:', data.peds ? Object.keys(data.peds).length : 0)
    console.log('[AppearanceStore] - peds sample:', data.peds ? JSON.stringify(data.peds).substring(0, 500) : 'null')
    console.log('[AppearanceStore] - tattoos:', data.tattoos ? Object.keys(data.tattoos).length : 0)
    console.log('[AppearanceStore] - config:', data.config)
    
    currentAppearance.value = data.appearance
    constants.value = data.constants
    peds.value = data.peds
    tattoos.value = data.tattoos
    config.value = data.config || {}
    pricing.value = data.pricing || null
    
    // Store initial appearance for cost calculation
    initialAppearance.value = JSON.parse(JSON.stringify(data.appearance))
    currentCost.value = 0
    itemizedCosts.value = []
    showCostConfirmation.value = false
    
    isOpen.value = true
    currentTab.value = data.config?.allowModelChange !== false ? 'model' : 'heritage'
    
    console.log('[AppearanceStore] Store state after open:')
    console.log('[AppearanceStore] - isOpen:', isOpen.value)
    console.log('[AppearanceStore] - currentTab:', currentTab.value)
    console.log('[AppearanceStore] - peds in store:', peds.value ? Object.keys(peds.value).length : 0)
  }
  
  function close() {
    isOpen.value = false
    currentAppearance.value = null
    constants.value = null
    peds.value = null
    tattoos.value = null
    config.value = {}
    pricing.value = null
    initialAppearance.value = null
    currentCost.value = 0
    itemizedCosts.value = []
    showCostConfirmation.value = false
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
      const index = currentAppearance.value.components.findIndex(c => ig.component_id === componentId)
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
  
  // Pricing helpers
  function getItemPrice(category, itemId) {
    if (!pricingEnabled.value) return 0
    
    const categoryPricing = pricing.value.pricing[category]
    if (!categoryPricing || !categoryPricing.enabled) return 0
    
    // Check for specific item price
    if (categoryPricing.items && categoryPricing.items[itemId] !== undefined) {
      return categoryPricing.items[itemId]
    }
    
    // Check for component-specific pricing (for clothing)
    if (categoryPricing.components && categoryPricing.components[itemId]) {
      const compPricing = categoryPricing.components[itemId]
      if (typeof compPricing === 'object' && compPricing.default !== undefined) {
        return compPricing.default
      }
      return compPricing
    }
    
    // Return default price
    return categoryPricing.default || 0
  }
  
  function calculateTotalCost() {
    if (!pricingEnabled.value || !initialAppearance.value) {
      currentCost.value = 0
      itemizedCosts.value = []
      return
    }
    
    let total = 0
    const costs = []
    
    // Helper to add cost
    const addCost = (category, itemId, price, description) => {
      if (price > 0) {
        costs.push({ category, itemId, price, description })
        total += price
      }
    }
    
    // Check hair changes
    if (pricing.value.pricing.hair && pricing.value.pricing.hair.enabled) {
      const oldHair = initialAppearance.value.hair || {}
      const newHair = currentAppearance.value.hair || {}
      
      if (oldHair.style !== newHair.style || oldHair.color !== newHair.color || oldHair.highlight !== newHair.highlight) {
        const price = getItemPrice('hair', newHair.style)
        addCost('hair', newHair.style, price, 'Hair Style Change')
      }
    }
    
    // Check clothing changes
    if (pricing.value.pricing.clothing && pricing.value.pricing.clothing.enabled) {
      const oldComponents = initialAppearance.value.components || []
      const newComponents = currentAppearance.value.components || []
      
      for (const newComp of newComponents) {
        let changed = true
        for (const oldComp of oldComponents) {
          if (oldComp.component_id === newComp.component_id &&
              oldComp.drawable === newComp.drawable &&
              oldComp.texture === newComp.texture) {
            changed = false
            break
          }
        }
        
        if (changed) {
          const price = getItemPrice('clothing', newComp.component_id)
          const compName = constants.value?.components?.find(c => ig.id === newComp.component_id)?.name || `Component ${newComp.component_id}`
          addCost('clothing', newComp.component_id, price, compName)
        }
      }
    }
    
    // Apply modifiers (employee discount, etig.)
    if (pricing.value.modifiers && pricing.value.modifiers.employee_discount) {
      total = Math.floor(total * pricing.value.modifiers.employee_discount)
    }
    
    currentCost.value = total
    itemizedCosts.value = costs
  }
  
  async function save() {
    isLoading.value = true
    try {
      // Calculate cost if pricing is enabled
      if (pricingEnabled.value) {
        calculateTotalCost()
        
        // Show confirmation if there's a cost
        if (currentCost.value > 0) {
          showCostConfirmation.value = true
          return // Don't save yet, wait for confirmation
        }
      }
      
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
  
  async function confirmPurchase() {
    isLoading.value = true
    try {
      showCostConfirmation.value = false
      await callClientCallback('Client:Appearance:Save')
      close()
    } finally {
      isLoading.value = false
    }
  }
  
  function cancelPurchase() {
    showCostConfirmation.value = false
  }
  
  async function cancel() {
    await callClientCallback('Client:Appearance:Cancel')
    close()
  }
  
  // Watch for appearance changes to recalculate cost
  watch(() => currentAppearance.value, () => {
    if (pricingEnabled.value && initialAppearance.value) {
      calculateTotalCost()
    }
  }, { deep: true })
  
  return {
    // State
    isOpen,
    currentAppearance,
    constants,
    peds,
    tattoos,
    config,
    pricing,
    currentTab,
    cameraMode,
    isLoading,
    
    // Pricing state
    initialAppearance,
    currentCost,
    itemizedCosts,
    showCostConfirmation,
    
    // Computed
    isFreemode,
    pedsByGender,
    tattoosByZone,
    pricingEnabled,
    
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
    cancel,
    
    // Pricing actions
    getItemPrice,
    calculateTotalCost,
    confirmPurchase,
    cancelPurchase
  }
})
