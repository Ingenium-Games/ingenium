import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useNotificationStore = defineStore('notifications', () => {
  const notifications = ref([])
  let notificationId = 0
  
  function addNotification({ text, color = 'black', fade = 13500 }) {
    const id = notificationId++
    const notification = {
      id,
      text,
      color,
      fade,
      visible: false
    }
    
    notifications.value.push(notification)
    
    // Fade in
    setTimeout(() => {
      const notif = notifications.value.find(n => n.id === id)
      if (notif) notif.visible = true
    }, 50)
    
    // Fade out and remove
    setTimeout(() => {
      const notif = notifications.value.find(n => n.id === id)
      if (notif) notif.visible = false
      
      setTimeout(() => {
        notifications.value = notifications.value.filter(n => n.id !== id)
      }, 750)
    }, fade / 2)
  }
  
  return {
    notifications,
    addNotification
  }
})
