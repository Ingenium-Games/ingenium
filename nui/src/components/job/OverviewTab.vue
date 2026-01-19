<template>
  <div class="overview-container">
    <div class="section">
      <h3 class="section-title">Job Information</h3>
      <div class="info-grid">
        <div class="info-card">
          <div class="card-label">Job Name</div>
          <div class="card-value">{{ jobStore.jobData.label }}</div>
        </div>
        <div class="info-card">
          <div class="card-label">Your Position</div>
          <div class="card-value">{{ jobStore.gradeName }}</div>
        </div>
        <div class="info-card">
          <div class="card-label">Total Members</div>
          <div class="card-value">{{ jobStore.jobData.members.length }}</div>
        </div>
        <div v-if="jobStore.userInfo.isBoss" class="info-card">
          <div class="card-label">Boss/Owner</div>
          <div class="card-value">You</div>
        </div>
      </div>
    </div>
    
    <div v-if="jobStore.jobData.description" class="section">
      <h3 class="section-title">Description</h3>
      <div class="description-box">
        <p>{{ jobStore.jobData.description }}</p>
      </div>
    </div>
    
    <div v-if="jobStore.userInfo.isBoss" class="section">
      <h3 class="section-title">Quick Actions</h3>
      <div class="action-grid">
        <button class="action-btn primary" @click="handleManageEmployees">
          <span class="btn-icon">👥</span>
          <span class="btn-text">Manage Employees</span>
        </button>
        <button class="action-btn secondary" @click="handleViewFinancials">
          <span class="btn-icon">📊</span>
          <span class="btn-text">View Financials</span>
        </button>
        <button class="action-btn secondary" @click="handleManageLocations">
          <span class="btn-icon">📍</span>
          <span class="btn-text">Manage Locations</span>
        </button>
        <button class="action-btn secondary" @click="handleEditPrices">
          <span class="btn-icon">💰</span>
          <span class="btn-text">Edit Prices</span>
        </button>
      </div>
    </div>
    
    <div v-if="!jobStore.userInfo.isBoss && jobStore.jobData.settings.allowEmployeeActions" class="section">
      <h3 class="section-title">Employee Actions</h3>
      <div class="description-box">
        <p class="muted-text">Check the Memos tab for important information from management.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useJobStore } from '../../stores/job'

const jobStore = useJobStore()

function handleManageEmployees() {
  jobStore.setActiveTab('employees')
}

function handleViewFinancials() {
  jobStore.setActiveTab('financials')
}

function handleManageLocations() {
  jobStore.setActiveTab('locations')
}

function handleEditPrices() {
  jobStore.setActiveTab('prices')
}
</script>

<style scoped>
.overview-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.section {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: white;
  margin: 0;
  padding-bottom: 8px;
  border-bottom: 2px solid rgba(66, 135, 245, 0.3);
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}

.info-card {
  padding: 16px;
  background: rgba(66, 135, 245, 0.05);
  border: 1px solid rgba(66, 135, 245, 0.2);
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.card-label {
  font-size: 12px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.5);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.card-value {
  font-size: 16px;
  font-weight: 700;
  color: white;
}

.description-box {
  padding: 16px;
  background: rgba(26, 26, 26, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
}

.description-box p {
  margin: 0;
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.6;
}

.muted-text {
  color: rgba(255, 255, 255, 0.5) !important;
  font-style: italic;
}

.action-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
}

.action-btn {
  padding: 16px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 14px;
  font-weight: 600;
}

.action-btn.primary {
  background: rgba(66, 135, 245, 0.2);
  border: 1px solid rgba(66, 135, 245, 0.4);
  color: #4287f5;
}

.action-btn.primary:hover {
  background: rgba(66, 135, 245, 0.3);
  border-color: rgba(66, 135, 245, 0.6);
  transform: translateY(-2px);
}

.action-btn.secondary {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.9);
}

.action-btn.secondary:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.btn-icon {
  font-size: 20px;
}

.btn-text {
  flex: 1;
  text-align: left;
}

/* Responsive Design */
@media (max-width: 600px) {
  .info-grid,
  .action-grid {
    grid-template-columns: 1fr;
  }
}
</style>
