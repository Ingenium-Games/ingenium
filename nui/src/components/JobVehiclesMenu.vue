<template>
  <div v-if="isVisible" class="job-vehicles-container">
    <div class="job-vehicles-menu">
      <div class="job-vehicles-header">
        <h2>{{ title }}</h2>
        <button @click="CloseMenu" class="close-btn">✕</button>
      </div>
      
      <div class="job-vehicles-content">
        <div v-if="vehicles.length === 0" class="no-vehicles">
          <p>No vehicles available</p>
        </div>
        
        <div v-else class="vehicles-grid">
          <div 
            v-for="(vehicle, index) in vehicles" 
            :key="index"
            class="vehicle-card"
            @click="SelectVehicle(index + 1)"
          >
            <div class="vehicle-icon">
              <i class="fas fa-car"></i>
            </div>
            <div class="vehicle-info">
              <h3>{{ vehicle.label }}</h3>
              <p v-if="vehicle.description">{{ vehicle.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const isVisible = ref(false)
const title = ref('Job Vehicles')
const spawnerId = ref(null)
const vehicles = ref([])

function OpenMenu(data) {
  title.value = data.title || 'Job Vehicles'
  spawnerId.value = data.spawnerId
  vehicles.value = data.vehicles || []
  isVisible.value = true
}

function CloseMenu() {
  isVisible.value = false
  spawnerId.value = null
  vehicles.value = []
  
  // Send close callback to Lua
  fetch(`https://${GetParentResourceName()}/JobVehicles:Close`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({})
  })
}

function SelectVehicle(vehicleIndex) {
  // Send selection to Lua
  fetch(`https://${GetParentResourceName()}/JobVehicles:SelectVehicle`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      spawnerId: spawnerId.value,
      vehicleIndex: vehicleIndex
    })
  })
}

function GetParentResourceName() {
  return window.GetParentResourceName ? window.GetParentResourceName() : 'ingenium'
}

function HandleMessage(event) {
  const data = event.data
  
  if (data.message === 'jobvehicles:open') {
    OpenMenu(data.data)
  } else if (data.message === 'jobvehicles:close') {
    CloseMenu()
  }
}

function HandleKeydown(event) {
  if (event.key === 'Escape' && isVisible.value) {
    CloseMenu()
  }
}

onMounted(() => {
  window.addEventListener('message', HandleMessage)
  window.addEventListener('keydown', HandleKeydown)
})

onUnmounted(() => {
  window.removeEventListener('message', HandleMessage)
  window.removeEventListener('keydown', HandleKeydown)
})
</script>

<style scoped>
.job-vehicles-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.7);
  z-index: 9999;
}

.job-vehicles-menu {
  background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
  width: 90%;
  max-width: 700px;
  max-height: 80vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.job-vehicles-header {
  background: rgba(0, 0, 0, 0.3);
  padding: 20px 25px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.job-vehicles-header h2 {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #ffffff;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.close-btn {
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid rgba(239, 68, 68, 0.5);
  color: #ef4444;
  font-size: 20px;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  background: rgba(239, 68, 68, 0.3);
  transform: scale(1.1);
}

.job-vehicles-content {
  padding: 25px;
  overflow-y: auto;
  flex: 1;
}

.no-vehicles {
  text-align: center;
  padding: 40px 20px;
  color: rgba(255, 255, 255, 0.6);
}

.no-vehicles p {
  margin: 0;
  font-size: 16px;
}

.vehicles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 15px;
}

.vehicle-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  padding: 20px;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.vehicle-card:hover {
  background: rgba(59, 130, 246, 0.15);
  border-color: rgba(59, 130, 246, 0.5);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(59, 130, 246, 0.3);
}

.vehicle-icon {
  font-size: 48px;
  color: #3b82f6;
  margin-bottom: 15px;
}

.vehicle-info h3 {
  margin: 0 0 8px 0;
  font-size: 16px;
  font-weight: 600;
  color: #ffffff;
}

.vehicle-info p {
  margin: 0;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
}

/* Scrollbar styling */
.job-vehicles-content::-webkit-scrollbar {
  width: 8px;
}

.job-vehicles-content::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 4px;
}

.job-vehicles-content::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
}

.job-vehicles-content::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>
