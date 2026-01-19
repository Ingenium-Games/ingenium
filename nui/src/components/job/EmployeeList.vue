<template>
  <div class="employee-container">
    <div class="section-header">
      <h3 class="section-title">Employee Management</h3>
      <button class="action-btn primary" @click="handleInviteEmployee">
        <span class="btn-icon">➕</span>
        <span>Invite Employee</span>
      </button>
    </div>
    
    <div v-if="jobStore.employees.length === 0" class="empty-state">
      <p>No employee data loaded. This will be populated from the server.</p>
    </div>
    
    <div v-else class="employee-list">
      <div 
        v-for="employee in jobStore.employees" 
        :key="employee.characterId"
        class="employee-card"
      >
        <div class="employee-info">
          <div class="employee-name">{{ employee.name }}</div>
          <div class="employee-details">
            <span class="detail-item">{{ employee.gradeName }}</span>
            <span class="detail-separator">•</span>
            <span class="detail-item">ID: {{ employee.characterId }}</span>
          </div>
          <div v-if="employee.lastSeen" class="employee-status">
            <span :class="['status-indicator', employee.online ? 'online' : 'offline']"></span>
            <span>{{ employee.online ? 'Online' : `Last seen: ${formatDate(employee.lastSeen)}` }}</span>
          </div>
        </div>
        
        <div class="employee-actions">
          <button 
            class="icon-btn" 
            @click="handlePromoteEmployee(employee)"
            title="Promote"
          >
            ⬆️
          </button>
          <button 
            class="icon-btn" 
            @click="handleDemoteEmployee(employee)"
            title="Demote"
          >
            ⬇️
          </button>
          <button 
            class="icon-btn danger" 
            @click="handleFireEmployee(employee)"
            title="Fire Employee"
          >
            🗑️
          </button>
        </div>
      </div>
    </div>
    
    <!-- Employee Stats -->
    <div v-if="jobStore.employees.length > 0" class="stats-section">
      <h4 class="stats-title">Employee Statistics</h4>
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-label">Total Employees</div>
          <div class="stat-value">{{ jobStore.employees.length }}</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Online Now</div>
          <div class="stat-value online">{{ onlineCount }}</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Offline</div>
          <div class="stat-value">{{ jobStore.employees.length - onlineCount }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useJobStore } from '../../stores/job'
import { sendNuiMessage } from '../../utils/nui'

const jobStore = useJobStore()

const onlineCount = computed(() => {
  return jobStore.employees.filter(e => e.online).length
})

function handleInviteEmployee() {
  sendNuiMessage('NUI:Client:JobInviteEmployee', {
    jobName: jobStore.jobData.name
  })
}

function handlePromoteEmployee(employee) {
  sendNuiMessage('NUI:Client:JobPromoteEmployee', {
    jobName: jobStore.jobData.name,
    characterId: employee.characterId
  })
}

function handleDemoteEmployee(employee) {
  sendNuiMessage('NUI:Client:JobDemoteEmployee', {
    jobName: jobStore.jobData.name,
    characterId: employee.characterId
  })
}

function handleFireEmployee(employee) {
  if (confirm(`Are you sure you want to fire ${employee.name}?`)) {
    sendNuiMessage('NUI:Client:JobFireEmployee', {
      jobName: jobStore.jobData.name,
      characterId: employee.characterId
    })
  }
}

function formatDate(timestamp) {
  const date = new Date(timestamp)
  const now = new Date()
  const diff = now - date
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  
  if (days === 0) {
    return 'Today'
  } else if (days === 1) {
    return 'Yesterday'
  } else if (days < 7) {
    return `${days} days ago`
  } else {
    return date.toLocaleDateString()
  }
}
</script>

<style scoped>
.employee-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: white;
  margin: 0;
}

.action-btn {
  padding: 10px 16px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 8px;
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
  transform: translateY(-1px);
}

.btn-icon {
  font-size: 16px;
}

.empty-state {
  padding: 40px 20px;
  text-align: center;
  color: rgba(255, 255, 255, 0.5);
  background: rgba(26, 26, 26, 0.5);
  border: 1px dashed rgba(255, 255, 255, 0.2);
  border-radius: 8px;
}

.empty-state p {
  margin: 0;
  font-style: italic;
}

.employee-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.employee-card {
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

.employee-card:hover {
  background: rgba(26, 26, 26, 0.7);
  border-color: rgba(255, 255, 255, 0.2);
}

.employee-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.employee-name {
  font-size: 16px;
  font-weight: 700;
  color: white;
}

.employee-details {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
}

.detail-separator {
  color: rgba(255, 255, 255, 0.3);
}

.employee-status {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}

.status-indicator {
  width: 8px;
  height: 8px;
  border-radius: 50%;
}

.status-indicator.online {
  background: #4ade80;
  box-shadow: 0 0 8px rgba(74, 222, 128, 0.5);
}

.status-indicator.offline {
  background: rgba(255, 255, 255, 0.3);
}

.employee-actions {
  display: flex;
  gap: 8px;
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

.stats-section {
  padding-top: 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.stats-title {
  font-size: 16px;
  font-weight: 600;
  color: white;
  margin: 0 0 12px 0;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 12px;
}

.stat-card {
  padding: 12px;
  background: rgba(66, 135, 245, 0.05);
  border: 1px solid rgba(66, 135, 245, 0.2);
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.stat-label {
  font-size: 11px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.5);
  text-transform: uppercase;
}

.stat-value {
  font-size: 20px;
  font-weight: 700;
  color: white;
}

.stat-value.online {
  color: #4ade80;
}

/* Responsive Design */
@media (max-width: 600px) {
  .employee-card {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .employee-actions {
    width: 100%;
    justify-content: flex-end;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
}
</style>
