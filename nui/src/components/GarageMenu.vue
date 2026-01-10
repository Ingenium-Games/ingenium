<template>
  <div v-if="isVisible" class="garage-container">
    <div class="garage-menu">
      <div class="garage-header">
        <h2>Garage and Parked Vehicles</h2>
        <button class="close-btn" @click="closeGarage">✕</button>
      </div>
      
      <div class="garage-content">
        <table class="garage-table">
          <thead>
            <tr>
              <th>Plate</th>
              <th>Name</th>
              <th>Retrieve</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(vehicle, index) in vehicles" :key="index">
              <td>{{ vehicle.Plate }}</td>
              <td>{{ vehicle.Model }}</td>
              <td>
                <button 
                  v-if="vehicle.Parked" 
                  class="return-btn"
                  @click="retrieveVehicle(vehicle.Plate)"
                >
                  Return Vehicle
                </button>
                <span v-else class="out-status">OUT</span>
              </td>
            </tr>
          </tbody>
        </table>
        
        <!-- Job Vehicles Section -->
        <GarageJobVehicles />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { sendNuiMessage } from '../utils/nui'
import GarageJobVehicles from './GarageJobVehicles.vue'

const isVisible = ref(false)
const vehicles = ref([])

function retrieveVehicle(plate) {
  sendNuiMessage('GUI:SelectVehicle', { Plate: plate })
}

function closeGarage() {
  sendNuiMessage('GUI:Close')
  isVisible.value = false
  vehicles.value = []
}

// Listen for NUI messages
if (typeof window !== 'undefined') {
  window.addEventListener('message', (event) => {
    const { message, data } = event.data

    switch (message) {
      case 'garage:open':
      case 'Open':
        isVisible.value = true
        vehicles.value = data || []
        break

      case 'garage:close':
      case 'Close':
        isVisible.value = false
        vehicles.value = []
        break
    }
  })

  // ESC key handler
  window.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && isVisible.value) {
      closeGarage()
    }
  })
}
</script>

<style scoped>
.garage-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.7);
  z-index: 1000;
}

.garage-menu {
  background: linear-gradient(135deg, #1e1e1e 0%, #2a2a2a 100%);
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
  width: 90%;
  max-width: 800px;
  max-height: 80vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.garage-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 30px;
  background: linear-gradient(90deg, #2c3e50 0%, #34495e 100%);
  border-bottom: 2px solid #3498db;
}

.garage-header h2 {
  margin: 0;
  color: #ecf0f1;
  font-size: 24px;
  font-weight: 600;
}

.close-btn {
  background: none;
  border: none;
  color: #ecf0f1;
  font-size: 24px;
  cursor: pointer;
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: all 0.2s;
}

.close-btn:hover {
  background: rgba(231, 76, 60, 0.2);
  color: #e74c3c;
}

.garage-content {
  padding: 20px;
  overflow-y: auto;
  flex: 1;
}

.garage-table {
  width: 100%;
  border-collapse: collapse;
  color: #ecf0f1;
}

.garage-table thead tr {
  background: rgba(52, 73, 94, 0.5);
  border-bottom: 2px solid #3498db;
}

.garage-table th {
  padding: 15px;
  text-align: left;
  font-weight: 600;
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.garage-table tbody tr {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  transition: background 0.2s;
}

.garage-table tbody tr:hover {
  background: rgba(52, 152, 219, 0.1);
}

.garage-table td {
  padding: 15px;
  font-size: 14px;
}

.return-btn {
  background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
  color: white;
  border: none;
  padding: 8px 20px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 13px;
  font-weight: 500;
  transition: all 0.2s;
  box-shadow: 0 2px 8px rgba(52, 152, 219, 0.3);
}

.return-btn:hover {
  background: linear-gradient(135deg, #2980b9 0%, #21618c 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
}

.return-btn:active {
  transform: translateY(0);
}

.out-status {
  color: #95a5a6;
  font-weight: 600;
  font-size: 13px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

/* Scrollbar styling */
.garage-content::-webkit-scrollbar {
  width: 8px;
}

.garage-content::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 4px;
}

.garage-content::-webkit-scrollbar-thumb {
  background: #3498db;
  border-radius: 4px;
}

.garage-content::-webkit-scrollbar-thumb:hover {
  background: #2980b9;
}
</style>
