<template>
  <div class="model-selector">
    <div class="selector-header">
      <input
        v-model="searchQuery"
        type="text"
        class="search-input"
        placeholder="Search models..."
        aria-label="Search models"
      />
      
      <div class="filter-buttons">
        <button
          v-for="filter in filters"
          :key="filter.value"
          @click="currentFilter = filter.value"
          :class="['filter-btn', { active: currentFilter === filter.value }]"
          :aria-label="`Filter by ${filter.label}`"
        >
          {{ filter.label }}
        </button>
      </div>
    </div>
    
    <div class="model-grid" ref="gridRef">
      <button
        v-for="ped in filteredPeds"
        :key="ped.hash"
        @click="selectModel(ped)"
        :class="['model-card', { 
          active: appearanceStore.currentAppearance?.model === ped.name,
          freemode: isFreemodePed(ped)
        }]"
        :aria-label="`Select model: ${ped.displayName}`"
      >
        <div class="model-name">{{ ped.displayName }}</div>
        <div v-if="isFreemodePed(ped)" class="freemode-badge">Freemode</div>
        <div v-if="ped.type" class="model-type">{{ ped.type }}</div>
      </button>
    </div>
    
    <div v-if="filteredPeds.length === 0" class="no-results">
      No models found
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'

const appearanceStore = useAppearanceStore()

const searchQuery = ref('')
const currentFilter = ref('all')
const gridRef = ref(null)

const filters = [
  { value: 'all', label: 'All' },
  { value: 'male', label: 'Male' },
  { value: 'female', label: 'Female' },
  { value: 'freemode', label: 'Custom' }
]

const filteredPeds = computed(() => {
  if (!appearanceStore.peds) return []
  
  let peds = Object.values(appearanceStore.peds)
  
  // Filter by search query
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    peds = peds.filter(ped => 
      ped.displayName.toLowerCase().includes(query) ||
      ped.name.toLowerCase().includes(query)
    )
  }
  
  // Filter by gender/type
  if (currentFilter.value === 'male') {
    peds = peds.filter(ped => ped.gender === 'male')
  } else if (currentFilter.value === 'female') {
    peds = peds.filter(ped => ped.gender === 'female')
  } else if (currentFilter.value === 'freemode') {
    peds = peds.filter(ped => isFreemodePed(ped))
  }
  
  // Sort: freemode first, then by name
  peds.sort((a, b) => {
    const aFreemode = isFreemodePed(a)
    const bFreemode = isFreemodePed(b)
    if (aFreemode && !bFreemode) return -1
    if (!aFreemode && bFreemode) return 1
    return a.displayName.localeCompare(b.displayName)
  })
  
  return peds
})

function isFreemodePed(ped) {
  return ped.name === 'mp_m_freemode_01' || ped.name === 'mp_f_freemode_01'
}

async function selectModel(ped) {
  await appearanceStore.updateModel(ped.name)
}
</script>

<style scoped>
.model-selector {
  display: flex;
  flex-direction: column;
  gap: 16px;
  height: 100%;
}

.selector-header {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.search-input {
  width: 100%;
  padding: 10px 14px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  color: white;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
}

.search-input:focus {
  border-color: rgba(66, 135, 245, 0.5);
}

.search-input::placeholder {
  color: rgba(255, 255, 255, 0.4);
}

.filter-buttons {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.filter-btn {
  padding: 6px 12px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.filter-btn:hover {
  background: rgba(58, 58, 58, 0.9);
  border-color: rgba(255, 255, 255, 0.2);
  color: white;
}

.filter-btn.active {
  background: rgba(66, 135, 245, 0.2);
  border-color: rgba(66, 135, 245, 0.5);
  color: #4287f5;
}

.model-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
  gap: 10px;
  overflow-y: auto;
  max-height: 500px;
  padding-right: 4px;
}

.model-grid::-webkit-scrollbar {
  width: 6px;
}

.model-grid::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 3px;
}

.model-grid::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.model-grid::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.model-card {
  position: relative;
  padding: 12px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  color: white;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
  text-align: center;
  min-height: 80px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 6px;
}

.model-card:hover {
  background: rgba(58, 58, 58, 0.9);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.model-card.active {
  background: rgba(66, 135, 245, 0.2);
  border-color: rgba(66, 135, 245, 0.6);
}

.model-card.freemode {
  border-color: rgba(76, 175, 80, 0.4);
}

.model-card.freemode.active {
  border-color: rgba(66, 135, 245, 0.6);
}

.model-name {
  font-weight: 600;
  word-break: break-word;
}

.freemode-badge {
  display: inline-block;
  padding: 2px 6px;
  background: rgba(76, 175, 80, 0.3);
  border: 1px solid rgba(76, 175, 80, 0.5);
  border-radius: 3px;
  font-size: 10px;
  color: #8bc34a;
  font-weight: 600;
  text-transform: uppercase;
}

.model-type {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.5);
  text-transform: capitalize;
}

.no-results {
  text-align: center;
  padding: 40px 20px;
  color: rgba(255, 255, 255, 0.5);
  font-size: 14px;
}
</style>
