<template>
  <div class="notification-window">
    <TransitionGroup name="notification">
      <div
        v-for="notification in notificationStore.notifications"
        :key="notification.id"
        :class="['notification', notification.color, { 'visible': notification.visible }]"
      >
        {{ notification.text }}
      </div>
    </TransitionGroup>
  </div>
</template>

<script setup>
import { useNotificationStore } from '../stores/notifications'

const notificationStore = useNotificationStore()
</script>

<style scoped>
.notification-window {
  position: fixed;
  top: 20px;
  right: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  z-index: 9999;
  pointer-events: none;
}

.notification {
  padding: 12px 20px;
  border-radius: 4px;
  color: white;
  font-size: 14px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
  opacity: 0;
  transform: translateX(100%);
  transition: all 0.75s ease;
  min-width: 200px;
  max-width: 400px;
  word-wrap: break-word;
}

.notification.visible {
  opacity: 1;
  transform: translateX(0);
}

/* Color variants */
.notification.black {
  background-color: #1a1a1a;
}

.notification.blue {
  background-color: #2563eb;
}

.notification.orange {
  background-color: #ea580c;
}

.notification.red {
  background-color: #dc2626;
}

.notification.green {
  background-color: #16a34a;
}

.notification.pink {
  background-color: #db2777;
}

.notification.purple {
  background-color: #9333ea;
}

.notification.yellow {
  background-color: #ca8a04;
}

/* Transition */
.notification-enter-active,
.notification-leave-active {
  transition: all 0.75s ease;
}

.notification-enter-from {
  opacity: 0;
  transform: translateX(100%);
}

.notification-leave-to {
  opacity: 0;
  transform: translateX(100%);
}
</style>
