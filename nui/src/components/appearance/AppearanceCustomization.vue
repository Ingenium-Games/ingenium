<template>
  <Transition name="fade">
    <div v-if="appearanceStore.isOpen" class="appearance-overlay">
      <div class="appearance-container">
        <div class="appearance-header">
          <h2 class="title">Appearance Customization</h2>
          <div class="header-actions">
            <div v-if="appearanceStore.isLoading" class="loading-indicator">
              <span class="spinner"></span>
              <span>Loading...</span>
            </div>
          </div>
        </div>
        
        <div class="appearance-content">
          <!-- Tab Navigation -->
          <div class="tab-navigation">
            <button
              v-for="tab in availableTabs"
              :key="tab.id"
              @click="appearanceStore.setTab(tab.id)"
              :class="['tab-btn', { active: appearanceStore.currentTab === tab.id }]"
              :aria-label="`${tab.label} tab`"
            >
              {{ tab.label }}
            </button>
          </div>
          
          <!-- Tab Content -->
          <div class="tab-content-wrapper">
            <div class="tab-content">
              <!-- Model Selection -->
              <ModelSelector v-if="appearanceStore.currentTab === 'model'" />
              
              <!-- Heritage -->
              <HeritageEditor v-if="appearanceStore.currentTab === 'heritage' && appearanceStore.isFreemode" />
              <div v-if="appearanceStore.currentTab === 'heritage' && !appearanceStore.isFreemode" class="not-available">
                Heritage customization is only available for freemode characters
              </div>
              
              <!-- Face Features -->
              <FaceFeaturesEditor v-if="appearanceStore.currentTab === 'face'" />
              
              <!-- Hair & Appearance -->
              <HairEditor v-if="appearanceStore.currentTab === 'hair'" />
              
              <!-- Overlays -->
              <OverlayEditor v-if="appearanceStore.currentTab === 'overlays'" />
              
              <!-- Clothing -->
              <ClothingEditor v-if="appearanceStore.currentTab === 'clothing'" />
              
              <!-- Accessories -->
              <AccessoriesEditor v-if="appearanceStore.currentTab === 'accessories'" />
              
              <!-- Tattoos -->
              <TattooEditor v-if="appearanceStore.currentTab === 'tattoos'" />
            </div>
            
            <!-- Camera Controls Sidebar -->
            <div class="camera-sidebar">
              <h3 class="sidebar-title">Camera</h3>
              <CameraControls />
            </div>
          </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="appearance-footer">
          <button
            @click="handleCancel"
            class="action-btn cancel-btn"
            :disabled="appearanceStore.isLoading"
            aria-label="Cancel"
          >
            Cancel
          </button>
          <button
            @click="handleSave"
            class="action-btn save-btn"
            :disabled="appearanceStore.isLoading"
            aria-label="Save"
          >
            Save
          </button>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { computed } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'
import ModelSelector from './ModelSelector.vue'
import HeritageEditor from './HeritageEditor.vue'
import FaceFeaturesEditor from './FaceFeaturesEditor.vue'
import HairEditor from './HairEditor.vue'
import OverlayEditor from './OverlayEditor.vue'
import ClothingEditor from './ClothingEditor.vue'
import AccessoriesEditor from './AccessoriesEditor.vue'
import TattooEditor from './TattooEditor.vue'
import CameraControls from './CameraControls.vue'

const appearanceStore = useAppearanceStore()

const availableTabs = computed(() => {
  const tabs = []
  
  // Model tab - only if config allows
  if (appearanceStore.config.allowModelChange !== false) {
    tabs.push({ id: 'model', label: 'Model' })
  }
  
  // Heritage tab - only for freemode
  if (appearanceStore.config.allowHeritage !== false) {
    tabs.push({ id: 'heritage', label: 'Heritage' })
  }
  
  // Face features
  if (appearanceStore.config.allowFaceFeatures !== false) {
    tabs.push({ id: 'face', label: 'Face Features' })
  }
  
  // Hair & Appearance
  if (appearanceStore.config.allowHair !== false) {
    tabs.push({ id: 'hair', label: 'Hair & Eyes' })
  }
  
  // Overlays (makeup, facial hair, etc)
  if (appearanceStore.config.allowOverlays !== false) {
    tabs.push({ id: 'overlays', label: 'Appearance' })
  }
  
  // Clothing
  if (appearanceStore.config.allowClothing !== false) {
    tabs.push({ id: 'clothing', label: 'Clothing' })
  }
  
  // Accessories
  if (appearanceStore.config.allowAccessories !== false) {
    tabs.push({ id: 'accessories', label: 'Accessories' })
  }
  
  // Tattoos
  if (appearanceStore.config.allowTattoos !== false) {
    tabs.push({ id: 'tattoos', label: 'Tattoos' })
  }
  
  return tabs
})

function handleSave() {
  appearanceStore.save()
}

function handleCancel() {
  appearanceStore.cancel()
}
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.appearance-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
  padding: 20px;
}

.appearance-container {
  width: 100%;
  max-width: 1200px;
  max-height: 90vh;
  background: linear-gradient(135deg, rgba(26, 26, 26, 0.98), rgba(42, 42, 42, 0.98));
  border-radius: 12px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.appearance-header {
  padding: 20px 25px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.title {
  font-size: 22px;
  font-weight: 700;
  color: white;
  margin: 0;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.loading-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #4287f5;
  font-size: 14px;
  font-weight: 500;
}

.spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(66, 135, 245, 0.3);
  border-top-color: #4287f5;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.appearance-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.tab-navigation {
  display: flex;
  gap: 4px;
  padding: 16px 20px 0 20px;
  overflow-x: auto;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.tab-navigation::-webkit-scrollbar {
  height: 4px;
}

.tab-navigation::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
}

.tab-navigation::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 2px;
}

.tab-btn {
  padding: 10px 18px;
  background: rgba(42, 42, 42, 0.5);
  border: none;
  border-bottom: 2px solid transparent;
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
}

.tab-btn:hover {
  background: rgba(58, 58, 58, 0.5);
  color: rgba(255, 255, 255, 0.9);
}

.tab-btn.active {
  color: #4287f5;
  border-bottom-color: #4287f5;
  background: rgba(66, 135, 245, 0.1);
}

.tab-content-wrapper {
  flex: 1;
  display: flex;
  gap: 20px;
  padding: 20px;
  overflow: hidden;
}

.tab-content {
  flex: 1;
  overflow-y: auto;
  padding-right: 8px;
}

.tab-content::-webkit-scrollbar {
  width: 8px;
}

.tab-content::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 4px;
}

.tab-content::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
}

.tab-content::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.camera-sidebar {
  width: 220px;
  flex-shrink: 0;
  padding: 16px;
  background: rgba(26, 26, 26, 0.5);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.sidebar-title {
  font-size: 14px;
  font-weight: 600;
  color: white;
  margin: 0;
}

.not-available {
  padding: 40px 20px;
  text-align: center;
  color: rgba(255, 255, 255, 0.5);
  font-size: 14px;
}

.appearance-footer {
  padding: 16px 25px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.action-btn {
  padding: 10px 24px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  min-width: 100px;
}

.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.cancel-btn {
  background: rgba(108, 117, 125, 0.2);
  border: 1px solid rgba(108, 117, 125, 0.4);
  color: #adb5bd;
}

.cancel-btn:hover:not(:disabled) {
  background: rgba(108, 117, 125, 0.3);
  border-color: rgba(108, 117, 125, 0.6);
  color: #dee2e6;
}

.save-btn {
  background: rgba(66, 135, 245, 0.2);
  border: 1px solid rgba(66, 135, 245, 0.4);
  color: #4287f5;
}

.save-btn:hover:not(:disabled) {
  background: rgba(66, 135, 245, 0.3);
  border-color: rgba(66, 135, 245, 0.6);
  transform: translateY(-1px);
}

.save-btn:active:not(:disabled) {
  transform: translateY(0);
}

/* Responsive Design */
@media (max-width: 900px) {
  .tab-content-wrapper {
    flex-direction: column;
  }
  
  .camera-sidebar {
    width: 100%;
  }
}

@media (max-width: 600px) {
  .appearance-container {
    max-height: 95vh;
  }
  
  .tab-navigation {
    padding: 12px 16px 0 16px;
  }
  
  .tab-btn {
    padding: 8px 14px;
    font-size: 13px;
  }
  
  .tab-content-wrapper {
    padding: 16px;
  }
}
</style>
