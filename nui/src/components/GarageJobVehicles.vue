<template>
  <div class="garage-job-vehicles">
    <div class="job-vehicles-header">
      <h3>Job Vehicles</h3>
    </div>
    
    <div class="job-vehicles-content">
      <div v-if="loading" class="loading-state">
        <div class="spinner"></div>
        <p>Loading job vehicles...</p>
      </div>
      
      <div v-else-if="vehicles.length === 0" class="empty-state">
        <p>No job vehicles available for your current position.</p>
      </div>
      
      <div v-else class="vehicles-list">
        <div 
          v-for="vehicle in vehicles" 
          :key="vehicle.model" 
          class="vehicle-card"
        >
          <div class="vehicle-info">
            <div class="vehicle-label">{{ vehicle.label }}</div>
            <div class="vehicle-model">{{ vehicle.model }}</div>
          </div>
          <button 
            class="spawn-btn" 
            @click="spawnVehicle(vehicle)"
          >
            Spawn
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

// Props
const props = defineProps({
  spawnCoords: { 
    type: Object, 
    default: null 
  }
})

// State
const vehicles = ref([])
const loading = ref(true)
let messageListener = null

// Methods
function requestVehicles() {
  loading.value = true
  // Emit to server using FiveM's native function
  if (typeof emitNet !== 'undefined') {
    emitNet('ingenium:requestJobVehicles')
  }
}

function spawnVehicle(vehicle) {
  const spawnCoords = props.spawnCoords || null
  
  // Emit spawn request to server
  if (typeof emitNet !== 'undefined') {
    emitNet('ingenium:spawnJobVehicle', { 
      model: vehicle.model, 
      spawnCoords: spawnCoords 
    })
  }
}

function handleJobVehiclesReceived(receivedVehicles) {
  vehicles.value = receivedVehicles || []
  loading.value = false
}

// Lifecycle
onMounted(() => {
  // Listen for server response using FiveM's native function
  if (typeof onNet !== 'undefined') {
    messageListener = onNet('ingenium:receiveJobVehicles', handleJobVehiclesReceived)
  }
  
  // Request vehicles from server
  requestVehicles()
})

onUnmounted(() => {
  // Clean up listener if needed
  // Note: FiveM's onNet doesn't require explicit cleanup in most cases
})
</script>

<style scoped>
.garage-job-vehicles {
  background: linear-gradient(135deg, #1e1e1e 0%, #2a2a2a 100%);
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
  margin-top: 20px;
}

.job-vehicles-header {
  background: linear-gradient(90deg, #2c3e50 0%, #34495e 100%);
  padding: 15px 20px;
  border-bottom: 2px solid #3498db;
}

.job-vehicles-header h3 {
  margin: 0;
  color: #ecf0f1;
  font-size: 18px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.job-vehicles-content {
  padding: 20px;
  min-height: 150px;
  max-height: 400px;
  overflow-y: auto;
}

/* Loading State */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 20px;
  color: #95a5a6;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(52, 152, 219, 0.2);
  border-top-color: #3498db;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-bottom: 15px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-state p {
  margin: 0;
  font-size: 14px;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: #7f8c8d;
  font-size: 14px;
}

.empty-state p {
  margin: 0;
}

/* Vehicles List */
.vehicles-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.vehicle-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(52, 73, 94, 0.3);
  border: 1px solid rgba(52, 152, 219, 0.2);
  border-radius: 6px;
  padding: 15px;
  transition: all 0.2s;
}

.vehicle-card:hover {
  background: rgba(52, 73, 94, 0.5);
  border-color: rgba(52, 152, 219, 0.4);
  transform: translateX(4px);
}

.vehicle-info {
  flex: 1;
}

.vehicle-label {
  color: #ecf0f1;
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 4px;
}

.vehicle-model {
  color: #95a5a6;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.spawn-btn {
  background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
  color: white;
  border: none;
  padding: 10px 24px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 13px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  transition: all 0.2s;
  box-shadow: 0 2px 8px rgba(52, 152, 219, 0.3);
}

.spawn-btn:hover {
  background: linear-gradient(135deg, #2980b9 0%, #21618c 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
}

.spawn-btn:active {
  transform: translateY(0);
}

/* Scrollbar Styling */
.job-vehicles-content::-webkit-scrollbar {
  width: 8px;
}

.job-vehicles-content::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 4px;
}

.job-vehicles-content::-webkit-scrollbar-thumb {
  background: #3498db;
  border-radius: 4px;
}

.job-vehicles-content::-webkit-scrollbar-thumb:hover {
  background: #2980b9;
}
</style>
