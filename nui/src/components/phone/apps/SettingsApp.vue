<template>
  <div class="settings-app">
    <div class="app-header">
      <h2>Settings</h2>
    </div>
    
    <div class="settings-content">
      <!-- Plane Mode -->
      <div class="setting-item">
        <div class="setting-info">
          <div class="setting-icon">✈️</div>
          <div class="setting-details">
            <div class="setting-name">Plane Mode</div>
            <div class="setting-description">Disable all calls and messages</div>
          </div>
        </div>
        <label class="toggle-switch">
          <input 
            type="checkbox" 
            v-model="localSettings.planeMode"
            @change="handlePlaneModeToggle"
          >
          <span class="toggle-slider"></span>
        </label>
      </div>
      
      <!-- Emergency Alerts -->
      <div class="setting-item" :class="{ 'setting-disabled': localSettings.planeMode }">
        <div class="setting-info">
          <div class="setting-icon">🚨</div>
          <div class="setting-details">
            <div class="setting-name">Emergency Alerts</div>
            <div class="setting-description">
              Alert medical services when downed
              <span v-if="localSettings.planeMode" class="disabled-hint">(Disabled in Plane Mode)</span>
            </div>
          </div>
        </div>
        <label class="toggle-switch">
          <input 
            type="checkbox" 
            v-model="localSettings.emergencyAlerts"
            :disabled="localSettings.planeMode"
            @change="handleSettingChange"
          >
          <span class="toggle-slider"></span>
        </label>
      </div>
      
      <!-- Provider and Phone Number -->
      <div class="info-section">
        <div class="info-item">
          <div class="info-label">Provider</div>
          <div class="info-value">{{ localSettings.provider }}</div>
        </div>
        <div class="info-item">
          <div class="info-label">Phone Number</div>
          <div class="info-value">{{ phoneStore.phoneData.phoneNumber || 'N/A' }}</div>
        </div>
        <div class="info-item">
          <div class="info-label">IMEI</div>
          <div class="info-value imei">{{ phoneStore.phoneData.imei || 'N/A' }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import { usePhoneStore } from '../../../stores/phone'
import { sendNuiMessage } from '../../../utils/nui'

const phoneStore = usePhoneStore()

// Local settings state
const localSettings = ref({
  planeMode: false,
  emergencyAlerts: true,
  provider: 'Warstock'
})

// Initialize local settings from store
onMounted(() => {
  localSettings.value = { ...phoneStore.phoneData.settings }
})

// Watch for changes from store (e.g., from server updates)
watch(() => phoneStore.phoneData.settings, (newSettings) => {
  localSettings.value = { ...newSettings }
}, { deep: true })

// Handle plane mode toggle
const handlePlaneModeToggle = () => {
  // If enabling plane mode, force emergency alerts off
  if (localSettings.value.planeMode) {
    localSettings.value.emergencyAlerts = false
  }
  handleSettingChange()
}

// Handle setting change
const handleSettingChange = () => {
  // Update store
  phoneStore.updateSettings(localSettings.value)
  
  // Send to server for persistence
  sendNuiMessage('NUI:Client:PhoneUpdateSettings', {
    settings: localSettings.value
  })
}
</script>

<style scoped>
.settings-app {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.app-header {
  padding: 20px;
  background: rgba(255, 255, 255, 0.05);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.app-header h2 {
  margin: 0;
  color: white;
  font-size: 24px;
  font-weight: 600;
}

.settings-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

/* Setting item */
.setting-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  margin-bottom: 12px;
  transition: background 0.2s;
}

.setting-item:hover:not(.setting-disabled) {
  background: rgba(255, 255, 255, 0.08);
}

.setting-item.setting-disabled {
  opacity: 0.5;
}

.setting-info {
  display: flex;
  align-items: center;
  gap: 16px;
  flex: 1;
}

.setting-icon {
  font-size: 28px;
  width: 40px;
  text-align: center;
}

.setting-details {
  flex: 1;
}

.setting-name {
  color: white;
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 4px;
}

.setting-description {
  color: rgba(255, 255, 255, 0.6);
  font-size: 13px;
}

.disabled-hint {
  color: rgba(255, 255, 255, 0.4);
  font-style: italic;
}

/* Toggle switch */
.toggle-switch {
  position: relative;
  display: inline-block;
  width: 52px;
  height: 28px;
  flex-shrink: 0;
}

.toggle-switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.toggle-slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(255, 255, 255, 0.2);
  transition: 0.3s;
  border-radius: 28px;
}

.toggle-slider:before {
  position: absolute;
  content: "";
  height: 20px;
  width: 20px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  transition: 0.3s;
  border-radius: 50%;
}

input:checked + .toggle-slider {
  background-color: #10b981;
}

input:checked + .toggle-slider:before {
  transform: translateX(24px);
}

input:disabled + .toggle-slider {
  cursor: not-allowed;
  opacity: 0.5;
}

/* Info section */
.info-section {
  margin-top: 24px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.03);
  border-radius: 12px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  padding: 12px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
  font-weight: 500;
}

.info-value {
  color: white;
  font-size: 14px;
  font-weight: 600;
}

.info-value.imei {
  font-family: 'Courier New', monospace;
  font-size: 12px;
  max-width: 200px;
  word-break: break-all;
  text-align: right;
}

/* Scrollbar */
.settings-content::-webkit-scrollbar {
  width: 6px;
}

.settings-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
}

.settings-content::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.settings-content::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>
