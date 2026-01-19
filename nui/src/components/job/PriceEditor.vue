<template>
  <div class="price-container">
    <div class="section-header">
      <h3 class="section-title">Price Management</h3>
      <p class="section-desc">Set prices for items sold at your business</p>
    </div>
    
    <div v-if="Object.keys(jobStore.jobData.prices).length === 0" class="empty-state">
      <p>No prices configured yet. Add items to set prices.</p>
      <button class="action-btn primary" @click="handleAddItem">
        <span>➕ Add Item</span>
      </button>
    </div>
    
    <div v-else class="price-list">
      <div 
        v-for="(price, item) in jobStore.jobData.prices" 
        :key="item"
        class="price-item"
      >
        <div class="item-info">
          <span class="item-name">{{ formatItemName(item) }}</span>
        </div>
        <div class="price-controls">
          <div class="price-input-group">
            <span class="currency">$</span>
            <input 
              type="number" 
              :value="price" 
              @change="handleUpdatePrice(item, $event.target.value)"
              class="price-input"
              min="0"
              step="0.01"
            />
          </div>
          <button class="icon-btn danger" @click="handleRemoveItem(item)">🗑️</button>
        </div>
      </div>
    </div>
    
    <div v-if="Object.keys(jobStore.jobData.prices).length > 0" class="action-section">
      <button class="action-btn primary" @click="handleAddItem">
        <span>➕ Add Item</span>
      </button>
      <button class="action-btn success" @click="handleSavePrices">
        <span>💾 Save Prices</span>
      </button>
    </div>
    
    <div class="help-box">
      <p>💡 <strong>Tip:</strong> Prices will be synced to all clients and used for sales transactions. Make sure to save after making changes.</p>
    </div>
  </div>
</template>

<script setup>
import { useJobStore } from '../../stores/job'
import { sendNuiMessage } from '../../utils/nui'

const jobStore = useJobStore()

function formatItemName(item) {
  // Convert snake_case or camelCase to Title Case
  return item
    .replace(/_/g, ' ')
    .replace(/([A-Z])/g, ' $1')
    .split(' ')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join(' ')
    .trim()
}

function handleUpdatePrice(item, value) {
  const price = parseFloat(value) || 0
  jobStore.jobData.prices[item] = price
}

function handleRemoveItem(item) {
  if (confirm(`Remove ${formatItemName(item)} from price list?`)) {
    delete jobStore.jobData.prices[item]
    sendNuiMessage('NUI:Client:JobRemovePrice', {
      jobName: jobStore.jobData.name,
      item: item
    })
  }
}

function handleAddItem() {
  sendNuiMessage('NUI:Client:JobAddPrice', {
    jobName: jobStore.jobData.name
  })
}

function handleSavePrices() {
  sendNuiMessage('NUI:Client:JobSavePrices', {
    jobName: jobStore.jobData.name,
    prices: jobStore.jobData.prices
  })
}
</script>

<style scoped>
.price-container {
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

.empty-state {
  padding: 40px 20px;
  text-align: center;
  background: rgba(26, 26, 26, 0.5);
  border: 1px dashed rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  align-items: center;
}

.empty-state p {
  margin: 0;
  color: rgba(255, 255, 255, 0.5);
  font-style: italic;
}

.price-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.price-item {
  padding: 16px;
  background: rgba(26, 26, 26, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  transition: all 0.2s;
}

.price-item:hover {
  background: rgba(26, 26, 26, 0.7);
  border-color: rgba(255, 255, 255, 0.2);
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 16px;
  font-weight: 600;
  color: white;
}

.price-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.price-input-group {
  display: flex;
  align-items: center;
  gap: 4px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 6px;
  padding: 8px 12px;
}

.currency {
  font-size: 14px;
  font-weight: 600;
  color: #4ade80;
}

.price-input {
  width: 100px;
  background: transparent;
  border: none;
  color: white;
  font-size: 14px;
  font-weight: 600;
  outline: none;
}

.price-input::-webkit-inner-spin-button,
.price-input::-webkit-outer-spin-button {
  opacity: 1;
}

.icon-btn {
  width: 36px;
  height: 36px;
  border: none;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  font-size: 16px;
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

.action-section {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.action-btn {
  padding: 12px 20px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
  font-weight: 600;
  flex: 1;
  min-width: 150px;
}

.action-btn.primary {
  background: rgba(66, 135, 245, 0.2);
  border: 1px solid rgba(66, 135, 245, 0.4);
  color: #4287f5;
}

.action-btn.primary:hover {
  background: rgba(66, 135, 245, 0.3);
  border-color: rgba(66, 135, 245, 0.6);
  transform: translateY(-1px);
}

.action-btn.success {
  background: rgba(74, 222, 128, 0.2);
  border: 1px solid rgba(74, 222, 128, 0.4);
  color: #4ade80;
}

.action-btn.success:hover {
  background: rgba(74, 222, 128, 0.3);
  border-color: rgba(74, 222, 128, 0.6);
  transform: translateY(-1px);
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

/* Responsive Design */
@media (max-width: 600px) {
  .price-item {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .price-controls {
    width: 100%;
    justify-content: space-between;
  }
  
  .action-section {
    flex-direction: column;
  }
  
  .action-btn {
    width: 100%;
  }
}
</style>
