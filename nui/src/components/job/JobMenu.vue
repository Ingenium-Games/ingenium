<template>
  <Transition name="fade">
    <div v-if="jobStore.isVisible" class="job-overlay">
      <div class="job-container">
        <!-- Header -->
        <div class="job-header">
          <div class="header-info">
            <h2 class="title">{{ jobStore.jobData.label || 'Job Management' }}</h2>
            <span class="subtitle">{{ jobStore.gradeName }}</span>
          </div>
          <button class="close-btn" @click="handleClose" aria-label="Close">✕</button>
        </div>
        
        <!-- Job Info Bar -->
        <div class="job-info-bar">
          <div class="info-item">
            <span class="info-label">Organization:</span>
            <span class="info-value">{{ jobStore.jobData.label }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Position:</span>
            <span class="info-value">{{ jobStore.gradeName }}</span>
          </div>
          <div v-if="jobStore.userInfo.isBoss" class="info-item">
            <span class="info-label">Safe:</span>
            <span class="info-value balance">{{ jobStore.formattedSafe }}</span>
          </div>
          <div v-if="jobStore.userInfo.isBoss" class="info-item">
            <span class="info-label">Bank:</span>
            <span class="info-value balance">{{ jobStore.formattedBank }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Members:</span>
            <span class="info-value">{{ jobStore.jobData.members.length }}</span>
          </div>
        </div>
        
        <!-- Tab Navigation -->
        <div class="job-tabs">
          <button
            v-for="tab in jobStore.availableTabs"
            :key="tab.id"
            :class="['tab-btn', { active: jobStore.activeTab === tab.id }]"
            @click="jobStore.setActiveTab(tab.id)"
            :aria-label="`${tab.label} tab`"
          >
            {{ tab.label }}
          </button>
        </div>
        
        <!-- Content Area -->
        <div class="job-content">
          <!-- Overview Tab -->
          <div v-if="jobStore.activeTab === 'overview'" class="tab-content">
            <OverviewTab />
          </div>
          
          <!-- Employees Tab (Boss only) -->
          <div v-if="jobStore.activeTab === 'employees' && jobStore.userInfo.isBoss" class="tab-content">
            <EmployeeList />
          </div>
          
          <!-- Locations Tab (Boss only) -->
          <div v-if="jobStore.activeTab === 'locations' && jobStore.userInfo.isBoss" class="tab-content">
            <LocationManager />
          </div>
          
          <!-- Prices Tab (Boss only) -->
          <div v-if="jobStore.activeTab === 'prices' && jobStore.userInfo.isBoss" class="tab-content">
            <PriceEditor />
          </div>
          
          <!-- Financials Tab -->
          <div v-if="jobStore.activeTab === 'financials'" class="tab-content">
            <FinancialReport />
          </div>
          
          <!-- Memos Tab -->
          <div v-if="jobStore.activeTab === 'memos'" class="tab-content">
            <MemoManager />
          </div>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { useJobStore } from '../../stores/job'
import { sendNuiMessage } from '../../utils/nui'
import OverviewTab from './OverviewTab.vue'
import EmployeeList from './EmployeeList.vue'
import LocationManager from './LocationManager.vue'
import PriceEditor from './PriceEditor.vue'
import FinancialReport from './FinancialReport.vue'
import MemoManager from './MemoManager.vue'

const jobStore = useJobStore()

function handleClose() {
  jobStore.close()
  sendNuiMessage('NUI:Client:JobClose')
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

.job-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
  pointer-events: all;
}

.job-container {
  width: 900px;
  max-width: 90vw;
  max-height: 85vh;
  background: linear-gradient(135deg, rgba(26, 26, 26, 0.98), rgba(42, 42, 42, 0.98));
  border-radius: 12px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.job-header {
  padding: 20px 25px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(135deg, rgba(66, 135, 245, 0.1), rgba(66, 135, 245, 0.05));
}

.header-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.title {
  font-size: 24px;
  font-weight: 700;
  color: white;
  margin: 0;
}

.subtitle {
  font-size: 14px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.6);
}

.close-btn {
  width: 32px;
  height: 32px;
  border: none;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  color: white;
  font-size: 20px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  background: rgba(255, 59, 48, 0.2);
  transform: scale(1.05);
}

.job-info-bar {
  padding: 16px 25px;
  background: rgba(26, 26, 26, 0.5);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  gap: 24px;
  flex-wrap: wrap;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-label {
  font-size: 11px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.5);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.info-value {
  font-size: 14px;
  font-weight: 600;
  color: white;
}

.info-value.balance {
  color: #4ade80;
}

.job-tabs {
  display: flex;
  gap: 4px;
  padding: 16px 20px 0 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  overflow-x: auto;
}

.job-tabs::-webkit-scrollbar {
  height: 4px;
}

.job-tabs::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
}

.job-tabs::-webkit-scrollbar-thumb {
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

.job-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px 25px;
}

.job-content::-webkit-scrollbar {
  width: 8px;
}

.job-content::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 4px;
}

.job-content::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
}

.job-content::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

.tab-content {
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Responsive Design */
@media (max-width: 900px) {
  .job-container {
    width: 95vw;
    max-height: 90vh;
  }
  
  .job-info-bar {
    gap: 16px;
  }
  
  .job-tabs {
    padding: 12px 16px 0 16px;
  }
  
  .tab-btn {
    padding: 8px 14px;
    font-size: 13px;
  }
  
  .job-content {
    padding: 16px 20px;
  }
}
</style>
