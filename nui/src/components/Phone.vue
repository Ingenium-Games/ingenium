<template>
  <Transition name="phone-slide">
    <div v-if="phoneStore.isVisible" class="phone-container">
      <div 
        class="phone-device"
        :class="{
          'phone-opening': phoneStore.animationState === 'opening',
          'phone-open': phoneStore.animationState === 'open',
          'phone-closing': phoneStore.animationState === 'closing'
        }"
      >
        <!-- Phone outer frame -->
        <div class="phone-frame">
          <!-- Lock screen -->
          <div v-if="!phoneStore.isUnlocked" class="lock-screen" @click="handleUnlock">
            <div class="lock-screen-content">
              <div class="time">{{ currentTime }}</div>
              <div class="date">{{ currentDate }}</div>
              <div class="unlock-hint">Click to unlock</div>
            </div>
          </div>
          
          <!-- Home screen / Apps -->
          <div v-else class="phone-screen">
            <!-- Status bar -->
            <div class="status-bar">
              <div class="status-left">
                <span v-if="phoneStore.isPlaneMode" class="status-icon">✈️</span>
                <span class="signal-bars">📶</span>
              </div>
              <div class="status-center">{{ currentTime }}</div>
              <div class="status-right">
                <span class="battery-icon">🔋</span>
              </div>
            </div>
            
            <!-- App content area -->
            <div class="app-content">
              <!-- Home screen -->
              <div v-if="phoneStore.currentApp === 'home'" class="home-screen">
                <div class="app-grid">
                  <div class="app-icon" @click="phoneStore.openApp('settings')">
                    <div class="icon">⚙️</div>
                    <div class="label">Settings</div>
                  </div>
                  <div class="app-icon" @click="phoneStore.openApp('contacts')">
                    <div class="icon">👤</div>
                    <div class="label">Contacts</div>
                  </div>
                  <!-- Placeholder for future apps -->
                  <div class="app-icon app-disabled">
                    <div class="icon">📱</div>
                    <div class="label">Calls</div>
                  </div>
                  <div class="app-icon app-disabled">
                    <div class="icon">💬</div>
                    <div class="label">Messages</div>
                  </div>
                </div>
              </div>
              
              <!-- Settings App -->
              <SettingsApp v-else-if="phoneStore.currentApp === 'settings'" />
              
              <!-- Contacts App -->
              <ContactsApp v-else-if="phoneStore.currentApp === 'contacts'" />
            </div>
            
            <!-- Navigation bar -->
            <div class="nav-bar">
              <button v-if="phoneStore.currentApp !== 'home'" @click="phoneStore.goHome" class="nav-button">
                🏠 Home
              </button>
              <button @click="handleClose" class="nav-button nav-close">
                ❌ Close
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { usePhoneStore } from '../stores/phone'
import { sendNuiMessage } from '../utils/nui'
import SettingsApp from './phone/apps/SettingsApp.vue'
import ContactsApp from './phone/apps/ContactsApp.vue'

const phoneStore = usePhoneStore()

// Current time and date
const currentTime = ref('')
const currentDate = ref('')

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })
  currentDate.value = now.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })
}

// Update time every second
let timeInterval = null
onMounted(() => {
  updateTime()
  timeInterval = setInterval(updateTime, 1000)
})

onUnmounted(() => {
  if (timeInterval) {
    clearInterval(timeInterval)
  }
})

// Handle unlock
const handleUnlock = () => {
  phoneStore.unlock()
}

// Handle close
const handleClose = () => {
  phoneStore.close()
  sendNuiMessage('NUI:Client:PhoneClose')
}
</script>

<style scoped>
.phone-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  pointer-events: none;
}

.phone-device {
  width: 380px;
  height: 760px;
  background: #1a1a1a;
  border-radius: 40px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.6);
  overflow: hidden;
  pointer-events: all;
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Animation states */
.phone-opening {
  animation: phoneSlideIn 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

.phone-closing {
  animation: phoneSlideOut 0.4s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

@keyframes phoneSlideIn {
  0% {
    transform: translateY(100%) scale(0.8);
    opacity: 0;
  }
  100% {
    transform: translateY(0) scale(1);
    opacity: 1;
  }
}

@keyframes phoneSlideOut {
  0% {
    transform: translateY(0) scale(1);
    opacity: 1;
  }
  100% {
    transform: translateY(100%) scale(0.8);
    opacity: 0;
  }
}

.phone-frame {
  width: 100%;
  height: 100%;
  padding: 10px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* Lock screen */
.lock-screen {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(20px);
  border-radius: 30px;
  cursor: pointer;
  transition: background 0.3s;
}

.lock-screen:hover {
  background: rgba(0, 0, 0, 0.4);
}

.lock-screen-content {
  text-align: center;
  color: white;
}

.lock-screen .time {
  font-size: 72px;
  font-weight: 200;
  margin-bottom: 10px;
}

.lock-screen .date {
  font-size: 20px;
  font-weight: 300;
  margin-bottom: 40px;
}

.lock-screen .unlock-hint {
  font-size: 16px;
  opacity: 0.7;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 0.7; }
  50% { opacity: 1; }
}

/* Phone screen */
.phone-screen {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #000;
  border-radius: 30px;
  overflow: hidden;
}

/* Status bar */
.status-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  background: rgba(0, 0, 0, 0.5);
  color: white;
  font-size: 14px;
}

.status-left, .status-right {
  display: flex;
  gap: 8px;
  align-items: center;
}

.status-icon {
  font-size: 16px;
}

/* App content */
.app-content {
  flex: 1;
  overflow-y: auto;
  background: #111;
}

/* Home screen */
.home-screen {
  padding: 40px 20px;
}

.app-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
}

.app-icon {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: transform 0.2s;
}

.app-icon:hover {
  transform: scale(1.1);
}

.app-icon.app-disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.app-icon.app-disabled:hover {
  transform: none;
}

.app-icon .icon {
  width: 70px;
  height: 70px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
  border-radius: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36px;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.app-icon .label {
  color: white;
  font-size: 13px;
  font-weight: 500;
}

/* Navigation bar */
.nav-bar {
  display: flex;
  justify-content: space-around;
  padding: 16px;
  background: rgba(0, 0, 0, 0.8);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.nav-button {
  padding: 12px 24px;
  background: rgba(255, 255, 255, 0.1);
  border: none;
  border-radius: 12px;
  color: white;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.nav-button:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.nav-button.nav-close {
  background: rgba(220, 38, 38, 0.2);
}

.nav-button.nav-close:hover {
  background: rgba(220, 38, 38, 0.4);
}

/* Scrollbar */
.app-content::-webkit-scrollbar {
  width: 6px;
}

.app-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
}

.app-content::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.app-content::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>
