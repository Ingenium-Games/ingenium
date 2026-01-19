<template>
  <div class="location-container">
    <div class="section-header">
      <h3 class="section-title">Location Management</h3>
      <p class="section-desc">Set important locations for your business operations</p>
    </div>
    
    <!-- Sales Points -->
    <div class="location-section">
      <h4 class="subsection-title">Sales Points</h4>
      <div class="location-list">
        <div 
          v-for="(location, index) in jobStore.jobData.locations.sales" 
          :key="`sales-${index}`"
          class="location-item"
        >
          <div class="location-info">
            <span class="location-name">{{ location.name || `Sales Point ${index + 1}` }}</span>
            <span class="location-coords">{{ formatCoords(location.coords) }}</span>
          </div>
          <button class="icon-btn danger" @click="handleRemoveLocation('sales', index)">🗑️</button>
        </div>
        <div v-if="jobStore.jobData.locations.sales.length === 0" class="empty-state">
          No sales points configured
        </div>
      </div>
      <button class="action-btn secondary" @click="handleAddSalesPoint">
        <span>➕ Add Sales Point</span>
      </button>
    </div>
    
    <!-- Delivery Points -->
    <div class="location-section">
      <h4 class="subsection-title">Delivery Points</h4>
      <div class="location-list">
        <div 
          v-for="(location, index) in jobStore.jobData.locations.delivery" 
          :key="`delivery-${index}`"
          class="location-item"
        >
          <div class="location-info">
            <span class="location-name">{{ location.name || `Delivery Point ${index + 1}` }}</span>
            <span class="location-coords">{{ formatCoords(location.coords) }}</span>
          </div>
          <button class="icon-btn danger" @click="handleRemoveLocation('delivery', index)">🗑️</button>
        </div>
        <div v-if="jobStore.jobData.locations.delivery.length === 0" class="empty-state">
          No delivery points configured
        </div>
      </div>
      <button class="action-btn secondary" @click="handleAddDeliveryPoint">
        <span>➕ Add Delivery Point</span>
      </button>
    </div>
    
    <!-- Safe Location -->
    <div class="location-section">
      <h4 class="subsection-title">Safe Location</h4>
      <div v-if="jobStore.jobData.locations.safe" class="location-item highlight">
        <div class="location-info">
          <span class="location-name">{{ jobStore.jobData.locations.safe.name || 'Job Safe' }}</span>
          <span class="location-coords">{{ formatCoords(jobStore.jobData.locations.safe.coords) }}</span>
        </div>
        <button class="icon-btn danger" @click="handleRemoveSafe">🗑️</button>
      </div>
      <div v-else class="empty-state">
        No safe location set
      </div>
      <button class="action-btn secondary" @click="handleSetSafe">
        <span>📍 Set Safe Location</span>
      </button>
    </div>
    
    <div class="help-box">
      <p>💡 <strong>Tip:</strong> These locations will be used for business operations. Sales points allow customers to purchase items, delivery points are for stock delivery, and the safe is where cash is stored.</p>
    </div>
  </div>
</template>

<script setup>
import { useJobStore } from '../../stores/job'
import { sendNuiMessage } from '../../utils/nui'

const jobStore = useJobStore()

function formatCoords(coords) {
  if (!coords) return 'Unknown'
  return `X: ${coords.x?.toFixed(1) || 0}, Y: ${coords.y?.toFixed(1) || 0}, Z: ${coords.z?.toFixed(1) || 0}`
}

function handleAddSalesPoint() {
  sendNuiMessage('NUI:Client:JobAddSalesPoint', {
    jobName: jobStore.jobData.name
  })
}

function handleAddDeliveryPoint() {
  sendNuiMessage('NUI:Client:JobAddDeliveryPoint', {
    jobName: jobStore.jobData.name
  })
}

function handleSetSafe() {
  sendNuiMessage('NUI:Client:JobSetSafe', {
    jobName: jobStore.jobData.name
  })
}

function handleRemoveLocation(type, index) {
  sendNuiMessage('NUI:Client:JobRemoveLocation', {
    jobName: jobStore.jobData.name,
    type: type,
    index: index
  })
}

function handleRemoveSafe() {
  sendNuiMessage('NUI:Client:JobRemoveSafe', {
    jobName: jobStore.jobData.name
  })
}
</script>

<style scoped>
.location-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.section-header {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: white;
  margin: 0;
}

.section-desc {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
  margin: 0;
}

.location-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px;
  background: rgba(26, 26, 26, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
}

.subsection-title {
  font-size: 16px;
  font-weight: 600;
  color: white;
  margin: 0;
}

.location-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.location-item {
  padding: 12px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.location-item.highlight {
  background: rgba(66, 135, 245, 0.1);
  border-color: rgba(66, 135, 245, 0.3);
}

.location-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.location-name {
  font-size: 14px;
  font-weight: 600;
  color: white;
}

.location-coords {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  font-family: monospace;
}

.empty-state {
  padding: 20px;
  text-align: center;
  color: rgba(255, 255, 255, 0.4);
  font-size: 13px;
  font-style: italic;
}

.action-btn {
  padding: 10px 16px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
  font-weight: 600;
}

.action-btn.secondary {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.9);
}

.action-btn.secondary:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-1px);
}

.icon-btn {
  width: 32px;
  height: 32px;
  border: none;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: scale(1.05);
}

.icon-btn.danger:hover {
  background: rgba(255, 59, 48, 0.2);
}

.help-box {
  padding: 16px;
  background: rgba(66, 135, 245, 0.05);
  border: 1px solid rgba(66, 135, 245, 0.2);
  border-radius: 8px;
}

.help-box p {
  margin: 0;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
}

.help-box strong {
  color: #4287f5;
}
</style>
