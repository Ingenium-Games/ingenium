<template>
  <div class="tattoo-editor">
    <div class="tattoo-header">
      <div class="zone-selector">
        <button
          v-for="zone in zones"
          :key="zone"
          @click="currentZone = zone"
          :class="['zone-btn', { active: currentZone === zone }]"
          :aria-label="`Select ${zone} zone`"
        >
          {{ formatZoneName(zone) }}
        </button>
      </div>
      
      <button
        @click="clearAll"
        class="clear-all-btn"
        :disabled="!hasTattoos"
        aria-label="Clear all tattoos"
      >
        Clear All
      </button>
    </div>
    
    <div class="applied-tattoos" v-if="appliedTattoos.length > 0">
      <h4 class="section-title">Applied Tattoos</h4>
      <div class="tattoo-chips">
        <div
          v-for="(tattoo, index) in appliedTattoos"
          :key="`${tattoo.collection}-${tattoo.hash}`"
          class="tattoo-chip"
        >
          <span>{{ getTattooLabel(tattoo) }}</span>
          <button
            @click="removeTattoo(tattoo)"
            class="remove-btn"
            aria-label="Remove tattoo"
          >
            ✖
          </button>
        </div>
      </div>
    </div>
    
    <div class="tattoo-list">
      <div
        v-for="tattoo in currentZoneTattoos"
        :key="`${tattoo.collection}-${tattoo.hashMale || tattoo.hashFemale}`"
        class="tattoo-item"
      >
        <div class="tattoo-info">
          <div class="tattoo-name">{{ tattoo.label }}</div>
          <div class="tattoo-collection">{{ tattoo.collection }}</div>
        </div>
        <button
          @click="applyTattoo(tattoo)"
          :class="['apply-btn', { applied: isTattooApplied(tattoo) }]"
          :aria-label="`Apply tattoo: ${tattoo.label}`"
        >
          {{ isTattooApplied(tattoo) ? '✓ Applied' : 'Apply' }}
        </button>
      </div>
      
      <div v-if="currentZoneTattoos.length === 0" class="no-tattoos">
        No tattoos available for this zone
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'

const appearanceStore = useAppearanceStore()

const currentZone = ref('ZONE_TORSO')

const zones = computed(() => {
  if (!appearanceStore.tattoos) return []
  return Object.keys(appearanceStore.tattoos)
})

const currentZoneTattoos = computed(() => {
  if (!appearanceStore.tattoos || !currentZone.value) return []
  return appearanceStore.tattoos[currentZone.value] || []
})

const appliedTattoos = computed(() => {
  return appearanceStore.currentAppearance?.tattoos || []
})

const hasTattoos = computed(() => {
  return appliedTattoos.value.length > 0
})

function formatZoneName(zone) {
  return zone.replace('ZONE_', '').replace(/_/g, ' ')
}

function isTattooApplied(tattoo) {
  const hash = getGenderHash(tattoo)
  return appliedTattoos.value.some(t => 
    t.collection === tattoo.collection && t.hash === hash
  )
}

function getGenderHash(tattoo) {
  const isFemale = appearanceStore.currentAppearance?.model === 'mp_f_freemode_01'
  return isFemale ? tattoo.hashFemale : tattoo.hashMale
}

function getTattooLabel(appliedTattoo) {
  // Try to find the tattoo in the current zone tattoos
  for (const zone of zones.value) {
    const zoneList = appearanceStore.tattoos[zone] || []
    const found = zoneList.find(t => {
      const hash = getGenderHash(t)
      return t.collection === appliedTattoo.collection && hash === appliedTattoo.hash
    })
    if (found) return found.label
  }
  return appliedTattoo.hash
}

function applyTattoo(tattoo) {
  const hash = getGenderHash(tattoo)
  appearanceStore.applyTattoo(tattoo.collection, hash)
}

function removeTattoo(tattoo) {
  appearanceStore.removeTattoo(tattoo.collection, tattoo.hash)
}

function clearAll() {
  if (confirm('Are you sure you want to remove all tattoos?')) {
    appearanceStore.clearAllTattoos()
  }
}
</script>

<style scoped>
.tattoo-editor {
  display: flex;
  flex-direction: column;
  gap: 16px;
  height: 100%;
}

.tattoo-header {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.zone-selector {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.zone-btn {
  padding: 6px 12px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 11px;
  font-weight: 500;
  text-transform: capitalize;
  cursor: pointer;
  transition: all 0.2s;
}

.zone-btn:hover {
  background: rgba(58, 58, 58, 0.9);
  border-color: rgba(255, 255, 255, 0.2);
  color: white;
}

.zone-btn.active {
  background: rgba(66, 135, 245, 0.2);
  border-color: rgba(66, 135, 245, 0.6);
  color: #4287f5;
}

.clear-all-btn {
  padding: 8px 16px;
  background: rgba(220, 53, 69, 0.2);
  border: 1px solid rgba(220, 53, 69, 0.4);
  border-radius: 6px;
  color: #dc3545;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.clear-all-btn:hover:not(:disabled) {
  background: rgba(220, 53, 69, 0.3);
  border-color: rgba(220, 53, 69, 0.6);
}

.clear-all-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.applied-tattoos {
  padding: 12px;
  background: rgba(26, 26, 26, 0.5);
  border-radius: 6px;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.section-title {
  font-size: 13px;
  font-weight: 600;
  color: white;
  margin: 0 0 8px 0;
}

.tattoo-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.tattoo-chip {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 4px 8px;
  background: rgba(66, 135, 245, 0.2);
  border: 1px solid rgba(66, 135, 245, 0.4);
  border-radius: 4px;
  font-size: 11px;
  color: #4287f5;
}

.tattoo-chip .remove-btn {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  padding: 2px;
  font-size: 10px;
  transition: color 0.2s;
}

.tattoo-chip .remove-btn:hover {
  color: #dc3545;
}

.tattoo-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  overflow-y: auto;
  max-height: 400px;
  padding-right: 4px;
}

.tattoo-list::-webkit-scrollbar {
  width: 6px;
}

.tattoo-list::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 3px;
}

.tattoo-list::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.tattoo-list::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.tattoo-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  background: rgba(42, 42, 42, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  transition: all 0.2s;
}

.tattoo-item:hover {
  background: rgba(58, 58, 58, 0.9);
  border-color: rgba(255, 255, 255, 0.2);
}

.tattoo-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
  flex: 1;
}

.tattoo-name {
  font-size: 13px;
  font-weight: 500;
  color: white;
}

.tattoo-collection {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.5);
}

.apply-btn {
  padding: 6px 12px;
  background: rgba(66, 135, 245, 0.2);
  border: 1px solid rgba(66, 135, 245, 0.4);
  border-radius: 4px;
  color: #4287f5;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
}

.apply-btn:hover {
  background: rgba(66, 135, 245, 0.3);
  border-color: rgba(66, 135, 245, 0.6);
}

.apply-btn.applied {
  background: rgba(76, 175, 80, 0.2);
  border-color: rgba(76, 175, 80, 0.4);
  color: #4caf50;
}

.no-tattoos {
  text-align: center;
  padding: 40px 20px;
  color: rgba(255, 255, 255, 0.5);
  font-size: 13px;
}
</style>
