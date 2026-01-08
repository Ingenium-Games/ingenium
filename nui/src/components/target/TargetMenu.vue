<template>
  <div v-if="isVisible" class="target-container">
    <!-- Eye icon -->
    <div class="target-eye">
      <svg 
        xmlns="http://www.w3.org/2000/svg" 
        height="36px" 
        viewBox="0 0 24 24" 
        width="36px" 
        :fill="hasTarget ? '#cfd2da' : '#000000'"
      >
        <path d="M0 0h24v24H0V0z" fill="none"/>
        <path d="M12 4C7 4 2.73 7.11 1 11.5 2.73 15.89 7 19 12 19s9.27-3.11 11-7.5C21.27 7.11 17 4 12 4zm0 12.5c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
      </svg>
    </div>

    <!-- Options list -->
    <div class="target-options">
      <template v-for="(typeOptions, type) in options" :key="type">
        <div
          v-for="(option, index) in typeOptions"
          :key="`${type}-${index}`"
          v-show="!option.hide"
          class="target-option"
          @click="selectOption(type, index + 1)"
        >
          <i 
            class="fa-fw option-icon" 
            :class="option.icon" 
            :style="{ color: option.iconColor || '#cfd2da' }"
          ></i>
          <p class="option-label">{{ option.label }}</p>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { sendNuiMessage } from '../../utils/nui'

const isVisible = ref(false)
const options = ref({})

const hasTarget = computed(() => {
  return Object.keys(options.value).length > 0
})

function selectOption(type, id) {
  sendNuiMessage('select', [type, id])
}

// Listen for NUI messages
if (typeof window !== 'undefined') {
  window.addEventListener('message', (event) => {
    const { event: eventName, state, options: newOptions } = event.data

    switch (eventName) {
      case 'visible':
        isVisible.value = state
        if (!state) {
          options.value = {}
        }
        break

      case 'leftTarget':
        options.value = {}
        break

      case 'setTarget':
        options.value = newOptions || {}
        break
    }
  })
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700&display=swap');

.target-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  user-select: none;
  white-space: nowrap;
}

.target-eye {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 22pt;
}

.target-options {
  position: absolute;
  top: calc(48.4%);
  left: calc(50% + 18pt);
}

.target-option {
  color: #cfd2da;
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  font-family: 'Nunito', sans-serif;
  background: linear-gradient(
    90deg,
    rgba(20, 20, 20, 0.7) 0%,
    rgba(20, 20, 20, 0.6) 66%,
    rgba(47, 48, 53, 0) 100%
  );
  font-size: 11pt;
  line-height: 22pt;
  vertical-align: middle;
  margin: 2pt;
  transition: 300ms;
  transform-origin: left top;
  scale: 1;
  height: 22pt;
  width: 150pt;
  pointer-events: auto;
  cursor: pointer;
}

.target-option:hover {
  background: linear-gradient(
    90deg,
    rgba(30, 30, 30, 0.7) 0%,
    rgba(30, 30, 30, 0.6) 66%,
    rgba(57, 58, 63, 0) 100%
  );
  transform-origin: left top;
  color: white;
  margin-left: 4pt;
}

.option-icon {
  font-size: 12pt;
  line-height: 22pt;
  width: 14pt;
  margin: 5pt;
}

.option-label {
  font-weight: 500;
  margin: 0;
}
</style>
