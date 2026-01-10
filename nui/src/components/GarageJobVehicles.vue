<template>
  <div v-if="isVisible" class="job-vehicles-section">
    <div class="section-header">
      <h3>Job Vehicles</h3>
      <span v-if="currentJob" class="job-badge">{{ currentJob }}</span>
    </div>
    
    <div v-if="vehicles.length === 0" class="no-vehicles">
      <p>No job vehicles available for your current position.</p>
    </div>
    
    <div v-else class="vehicles-grid">
      <div 
        v-for="(vehicle, index) in vehicles" 
        :key="index"
        class="vehicle-card"
      >
        <div class="vehicle-info">
          <h4>{{ vehicle.name }}</h4>
          <p class="vehicle-model">{{ vehicle.model }}</p>
          <p v-if="vehicle.description" class="vehicle-description">
            {{ vehicle.description }}
          </p>
          <div class="vehicle-requirements">
            <span class="grade-badge">Min. Grade: {{ vehicle.minGrade }}</span>
          </div>
        </div>
        <button 
          class="spawn-btn"
          @click="spawnVehicle(vehicle.model, vehicle.name)"
          :disabled="isSpawning"
        >
          {{ isSpawning ? 'Spawning...' : 'Spawn Vehicle' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { sendNuiMessage } from '../utils/nui'

const isVisible = ref(false)
const vehicles = ref([])
const currentJob = ref('')
const isSpawning = ref(false)

async function loadJobVehicles() {
  try {
    // Request job vehicles from server via client callback
    sendNuiMessage('jobVehicles:request')
  } catch (error) {
    console.error('Failed to load job vehicles:', error)
  }
}

function spawnVehicle(model, name) {
  if (isSpawning.value) return
  
  isSpawning.value = true
  sendNuiMessage('jobVehicles:spawn', { model, name })
  
  // Reset spawning state after a delay
  setTimeout(() => {
    isSpawning.value = false
  }, 2000)
}

// Listen for NUI messages
if (typeof window !== 'undefined') {
  window.addEventListener('message', (event) => {
    const { message, data } = event.data

    switch (message) {
      case 'jobVehicles:show':
        isVisible.value = true
        vehicles.value = data.vehicles || []
        currentJob.value = data.job || ''
        break

      case 'jobVehicles:hide':
        isVisible.value = false
        vehicles.value = []
        currentJob.value = ''
        break

      case 'jobVehicles:update':
        vehicles.value = data.vehicles || []
        currentJob.value = data.job || ''
        break
    }
  })
}

onMounted(() => {
  // Component is mounted and ready
})
</script>

<style scoped>
.job-vehicles-section {
  margin-top: 20px;
  padding: 20px;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 2px solid #3498db;
}

.section-header h3 {
  margin: 0;
  color: #ecf0f1;
  font-size: 20px;
  font-weight: 600;
}

.job-badge {
  background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
  color: white;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.no-vehicles {
  text-align: center;
  padding: 30px;
  color: #95a5a6;
}

.no-vehicles p {
  margin: 0;
  font-size: 14px;
}

.vehicles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 15px;
}

.vehicle-card {
  background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
  border-radius: 8px;
  padding: 15px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.vehicle-card:hover {
  border-color: #3498db;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
}

.vehicle-info {
  flex: 1;
}

.vehicle-info h4 {
  margin: 0 0 8px 0;
  color: #ecf0f1;
  font-size: 16px;
  font-weight: 600;
}

.vehicle-model {
  margin: 0 0 8px 0;
  color: #3498db;
  font-size: 13px;
  font-weight: 500;
  font-family: monospace;
}

.vehicle-description {
  margin: 0 0 12px 0;
  color: #bdc3c7;
  font-size: 13px;
  line-height: 1.4;
}

.vehicle-requirements {
  margin-bottom: 12px;
}

.grade-badge {
  display: inline-block;
  background: rgba(52, 152, 219, 0.2);
  color: #3498db;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border: 1px solid rgba(52, 152, 219, 0.3);
}

.spawn-btn {
  width: 100%;
  background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
  color: white;
  border: none;
  padding: 10px 16px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 13px;
  font-weight: 600;
  transition: all 0.2s;
  box-shadow: 0 2px 8px rgba(39, 174, 96, 0.3);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.spawn-btn:hover:not(:disabled) {
  background: linear-gradient(135deg, #229954 0%, #1e8449 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(39, 174, 96, 0.4);
}

.spawn-btn:active:not(:disabled) {
  transform: translateY(0);
}

.spawn-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
