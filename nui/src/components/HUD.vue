<template>
  <div class="hud-container">
    <div class="hud-stats">
      <!-- Health -->
      <div class="hud-stat">
        <span class="hud-stat-label">Health</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill health" :style="{ width: `${uiStore.hudData.health}%` }"></div>
        </div>
      </div>
      
      <!-- Armor -->
      <div class="hud-stat" v-if="uiStore.hudData.armor > 0">
        <span class="hud-stat-label">Armor</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill armor" :style="{ width: `${uiStore.hudData.armor}%` }"></div>
        </div>
      </div>
      
      <!-- Hunger -->
      <div class="hud-stat">
        <span class="hud-stat-label">Hunger</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill hunger" :style="{ width: `${uiStore.hudData.hunger}%` }"></div>
        </div>
      </div>
      
      <!-- Thirst -->
      <div class="hud-stat">
        <span class="hud-stat-label">Thirst</span>
        <div class="hud-stat-bar">
          <div class="hud-stat-fill thirst" :style="{ width: `${uiStore.hudData.thirst}%` }"></div>
        </div>
      </div>
    </div>
    
    <div class="hud-info">
      <div class="hud-money">
        <span class="hud-cash">${{ formatMoney(uiStore.hudData.cash) }}</span>
        <span class="hud-bank">Bank: ${{ formatMoney(uiStore.hudData.bank) }}</span>
      </div>
      
      <div class="hud-job" v-if="uiStore.hudData.job">
        {{ uiStore.hudData.job }} <span v-if="uiStore.hudData.jobGrade">- {{ uiStore.hudData.jobGrade }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useUIStore } from '../stores/ui'

const uiStore = useUIStore()

function formatMoney(value) {
  if (value === null || value === undefined || isNaN(value)) {
    return '0'
  }
  return Number(value).toLocaleString()
}
</script>

<style scoped>
.hud-container {
  position: fixed;
  bottom: 20px;
  left: 20px;
  display: flex;
  flex-direction: column;
  gap: 15px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.hud-stats {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.hud-stat {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.hud-stat-label {
  color: white;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.8);
}

.hud-stat-bar {
  width: 200px;
  height: 8px;
  background-color: rgba(0, 0, 0, 0.5);
  border-radius: 4px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
}

.hud-stat-fill {
  height: 100%;
  transition: width 0.3s ease;
}

.hud-stat-fill.health {
  background: linear-gradient(90deg, #dc2626, #ef4444);
}

.hud-stat-fill.armor {
  background: linear-gradient(90deg, #2563eb, #3b82f6);
}

.hud-stat-fill.hunger {
  background: linear-gradient(90deg, #ea580c, #f97316);
}

.hud-stat-fill.thirst {
  background: linear-gradient(90deg, #0891b2, #06b6d4);
}

.hud-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.hud-money {
  display: flex;
  flex-direction: column;
  gap: 4px;
  color: white;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.8);
}

.hud-cash {
  font-size: 18px;
  font-weight: 700;
  color: #10b981;
}

.hud-bank {
  font-size: 12px;
  font-weight: 500;
  color: #60a5fa;
}

.hud-job {
  font-size: 12px;
  font-weight: 500;
  color: white;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.8);
}
</style>
