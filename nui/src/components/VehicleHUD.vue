<template>
  <div v-if="isVisible" class="vehicle-hud">
    <!-- Speed Display -->
    <div class="vehicle-stat">
      <i class="fa-solid fa-gauge-high stat-icon"></i>
      <div class="stat-content">
        <span class="stat-value">{{ speed }}</span>
        <span class="stat-unit">{{ speedUnit }}</span>
      </div>
    </div>

    <!-- Fuel Display -->
    <div class="vehicle-stat">
      <i class="fa-solid fa-gas-pump stat-icon"></i>
      <div class="stat-content">
        <div class="fuel-bar-container">
          <div class="fuel-bar" :style="{ width: fuel + '%' }"></div>
        </div>
        <span class="stat-value">{{ fuel }}%</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const isVisible = ref(false)
const speed = ref(0)
const fuel = ref(100)
const speedUnit = ref('MPH')

function handleVehicleHudMessage(event) {
  const { event: eventName, data } = event.data

  if (eventName === 'vehicleHudUpdate') {
    isVisible.value = data.visible
    if (data.visible) {
      speed.value = data.speed || 0
      fuel.value = data.fuel || 0
      speedUnit.value = data.unit || 'MPH'
    }
  }
}

onMounted(() => {
  if (typeof window !== 'undefined') {
    window.addEventListener('message', handleVehicleHudMessage)
  }
})

onUnmounted(() => {
  if (typeof window !== 'undefined') {
    window.removeEventListener('message', handleVehicleHudMessage)
  }
})
</script>

<style scoped>
.vehicle-hud {
  position: fixed;
  bottom: 20px;
  right: 20px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  pointer-events: none;
  user-select: none;
  z-index: 100;
}

.vehicle-stat {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 16px;
  background: rgba(0, 0, 0, 0.6);
  border-radius: 8px;
  backdrop-filter: blur(10px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
  min-width: 180px;
}

.stat-icon {
  color: #3b82f6;
  font-size: 24px;
  width: 30px;
  text-align: center;
}

.stat-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
}

.stat-value {
  color: #ffffff;
  font-size: 20px;
  font-weight: 600;
  line-height: 1;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.8);
}

.stat-unit {
  color: #9ca3af;
  font-size: 12px;
  font-weight: 500;
  text-transform: uppercase;
}

.fuel-bar-container {
  height: 6px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
  overflow: hidden;
  margin-bottom: 4px;
}

.fuel-bar {
  height: 100%;
  background: linear-gradient(90deg, #ef4444 0%, #f59e0b 50%, #22c55e 100%);
  transition: width 0.3s ease;
  border-radius: 3px;
}
</style>
