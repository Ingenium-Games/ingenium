<template>
  <Transition name="box-open">
    <div v-if="isVisible || isLoading" class="inventory-container">
      <!-- Loading Spinner -->
      <div v-if="isLoading" class="loading-overlay">
        <div class="loading-spinner"></div>
        <div class="loading-text">Loading {{ loadingTitle }}...</div>
      </div>
      
      <!-- Timeout Error Message -->
      <div v-else-if="hasTimeout" class="timeout-overlay">
        <div class="timeout-icon">⚠️</div>
        <div class="timeout-title">Connection Timeout</div>
        <div class="timeout-message">{{ timeoutMessage }}</div>
        <button class="timeout-button" @click="closeInventory">Close</button>
      </div>
      
      <!-- Inventory Content -->
      <div 
        v-else
        ref="inventoryWrapper"
        class="inventory-wrapper"
        :style="wrapperStyle"
        @mousedown="startDrag"
      >
        <div class="drag-handle" @mousedown.stop="startDrag">
          <span class="drag-indicator">⠿</span>
          <span class="drag-text">Inventory</span>
          <button class="close-button" @click="closeInventory">✕</button>
        </div>
        
        <div class="inventory-panels">
          <!-- Left Panel - External Storage/Object (only shown in dual mode) -->
          <InventoryPanel
            v-if="isDualMode"
            :title="externalTitle"
            :items="externalInventory"
            :maxSlots="externalMaxSlots"
            panel-id="external"
            @update-items="updateExternalInventory"
            @item-action="handleItemAction"
          />
          
          <!-- Right Panel - Player Inventory -->
          <InventoryPanel
            :title="'Player Inventory'"
            :items="playerInventory"
            :maxSlots="playerMaxSlots"
            panel-id="player"
            @update-items="updatePlayerInventory"
            @item-action="handleItemAction"
          />
        </div>
      </div>
    </div>
  </Transition>
</template>

<script>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import InventoryPanel from './components/InventoryPanel.vue'

// Configuration constants
const RESOURCE_NAME = 'ingenium'  // Can be changed if resource is renamed

export default {
  name: 'App',
  components: {
    InventoryPanel
  },
  setup() {
    const isVisible = ref(false)
    const isLoading = ref(false)
    const hasTimeout = ref(false)
    const loadingTitle = ref('')
    const timeoutMessage = ref('Failed to load inventory data. Please close and try again.')
    const isDualMode = ref(false)
    const externalTitle = ref('Storage')
    const externalInventory = ref([])
    const playerInventory = ref([])
    const externalMaxSlots = ref(50)
    const playerMaxSlots = ref(50)
    const externalNetId = ref(null)
    
    // Draggable state
    const inventoryWrapper = ref(null)
    const isDragging = ref(false)
    const dragOffset = ref({ x: 0, y: 0 })
    const position = ref({ x: 0, y: 0 })
    
    // Computed style for wrapper position
    const wrapperStyle = computed(() => {
      if (position.value.x === 0 && position.value.y === 0) {
        return {}
      }
      return {
        transform: `translate(${position.value.x}px, ${position.value.y}px)`
      }
    })

    /**
     * Load saved window position from localStorage
     */
    const loadWindowPosition = () => {
      try {
        const saved = localStorage.getItem('inventory_window_position')
        if (saved) {
          const pos = JSON.parse(saved)
          position.value = pos
        }
      } catch (e) {
        console.error('Error loading window position:', e)
      }
    }
    
    /**
     * Save window position to localStorage
     */
    const saveWindowPosition = () => {
      try {
        localStorage.setItem('inventory_window_position', JSON.stringify(position.value))
      } catch (e) {
        console.error('Error saving window position:', e)
      }
    }
    
    /**
     * Load saved inventory positions from localStorage
     * @param {string} panelId - The panel identifier
     * @returns {Array} Saved inventory items or empty array
     */
    const loadInventoryPositions = (panelId) => {
      try {
        const saved = localStorage.getItem(`inventory_${panelId}`)
        return saved ? JSON.parse(saved) : []
      } catch (e) {
        console.error('Error loading inventory positions:', e)
        return []
      }
    }

    /**
     * Save inventory positions to localStorage
     * @param {string} panelId - The panel identifier
     * @param {Array} items - Inventory items to save
     */
    const saveInventoryPositions = (panelId, items) => {
      try {
        localStorage.setItem(`inventory_${panelId}`, JSON.stringify(items))
      } catch (e) {
        console.error('Error saving inventory positions:', e)
      }
    }

    /**
     * Load and merge inventory data (shared between single and dual modes)
     * @param {Object} data - Inventory data from server
     * @param {boolean} dualMode - Whether to load external inventory
     */
    const loadAndMergeInventory = (data, dualMode) => {
      // Load player inventory
      playerInventory.value = mergeInventoryWithPositions(
        data.playerInventory || [],
        loadInventoryPositions('player')
      )
      playerMaxSlots.value = data.playerMaxSlots || 50
      
      // Load external inventory if in dual mode
      if (dualMode) {
        externalTitle.value = data.externalTitle || 'Storage'
        externalNetId.value = data.externalNetId
        externalInventory.value = mergeInventoryWithPositions(
          data.externalInventory || [],
          loadInventoryPositions(`external_${data.externalNetId}`)
        )
        externalMaxSlots.value = data.externalMaxSlots || 50
      } else {
        externalTitle.value = ''
        externalNetId.value = null
        externalInventory.value = []
        externalMaxSlots.value = 0
      }
      
      isDualMode.value = dualMode
      isVisible.value = true
      loadWindowPosition()
    }
    
    /**
     * Handle NUI message events from FiveM
     */
    const handleMessage = (event) => {
      const { message, data } = event.data

      switch (message) {
        case 'Client:NUI:InventoryLoading':
          // Show loading spinner
          isLoading.value = true
          hasTimeout.value = false
          isVisible.value = false
          loadingTitle.value = data.title || 'Inventory'
          break

        case 'Client:NUI:InventoryTimeout':
          // Show timeout error
          isLoading.value = false
          hasTimeout.value = true
          timeoutMessage.value = data.error || 'Failed to load inventory data. Please close and try again.'
          break

        case 'Client:NUI:InventoryOpenDual':
          // Hide loading, show inventory
          isLoading.value = false
          hasTimeout.value = false
          loadAndMergeInventory(data, true)
          break

        case 'Client:NUI:InventoryOpenSingle':
          // Hide loading, show inventory
          isLoading.value = false
          hasTimeout.value = false
          loadAndMergeInventory(data, false)
          break

        case 'Client:NUI:InventoryClose':
          isVisible.value = false
          isLoading.value = false
          hasTimeout.value = false
          closeInventory()
          break

        case 'Client:NUI:InventoryUpdate':
          // Update inventory from server
          if (data.playerInventory) {
            playerInventory.value = mergeInventoryWithPositions(
              data.playerInventory,
              loadInventoryPositions('player')
            )
          }
          if (data.externalInventory && isDualMode.value) {
            externalInventory.value = mergeInventoryWithPositions(
              data.externalInventory,
              loadInventoryPositions(`external_${externalNetId.value}`)
            )
          }
          break
      }
    }

    /**
     * Merge server inventory data with client-saved positions
     * @param {Array} serverItems - Items from server
     * @param {Array} savedPositions - Saved positions from localStorage
     * @returns {Array} Merged inventory
     */
    const mergeInventoryWithPositions = (serverItems, savedPositions) => {
      // Create a map of saved positions by item unique identifier
      const positionMap = new Map()
      savedPositions.forEach((item, index) => {
        if (item) {
          const key = `${item.Item}_${item.Meta?.SerialNumber || ''}`
          positionMap.set(key, index)
        }
      })

      // Create result array with max slots
      const result = []
      const usedPositions = new Set()

      // First, place items at their saved positions
      serverItems.forEach(item => {
        const key = `${item.Item}_${item.Meta?.SerialNumber || ''}`
        const savedPos = positionMap.get(key)
        
        if (savedPos !== undefined && !usedPositions.has(savedPos)) {
          result[savedPos] = item
          usedPositions.add(savedPos)
        }
      })

      // Then, place remaining items in first available slots
      serverItems.forEach(item => {
        const key = `${item.Item}_${item.Meta?.SerialNumber || ''}`
        const savedPos = positionMap.get(key)
        
        if (savedPos === undefined || usedPositions.has(savedPos)) {
          // Find first empty slot
          for (let i = 0; i < 100; i++) {
            if (!result[i] && !usedPositions.has(i)) {
              result[i] = item
              usedPositions.add(i)
              break
            }
          }
        }
      })

      return result
    }

    /**
     * Update external inventory items
     */
    const updateExternalInventory = (items) => {
      externalInventory.value = items
      saveInventoryPositions(`external_${externalNetId.value}`, items)
    }

    /**
     * Update player inventory items
     */
    const updatePlayerInventory = (items) => {
      playerInventory.value = items
      saveInventoryPositions('player', items)
    }

    /**
     * Handle item actions (Use, Give, Drop)
     */
    const handleItemAction = ({ action, item, position, panelId }) => {
      // Send action to Lua backend
      fetch(`https://${RESOURCE_NAME}/NUI:Client:InventoryAction`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          action,
          item,
          position,
          panelId
        })
      }).catch(err => {
        console.error('Error sending item action:', err)
      })
    }

    /**
     * Close inventory and save to server
     */
    const closeInventory = () => {
      // Clear loading and timeout states
      isLoading.value = false
      hasTimeout.value = false
      
      // Only send close data if inventory was actually open
      if (isVisible.value && (playerInventory.value.length > 0 || externalInventory.value.length > 0)) {
        // Compress inventory arrays (remove empty slots for server transmission)
        const compressedPlayer = playerInventory.value.filter(item => item != null)
        const compressedExternal = externalInventory.value.filter(item => item != null)

        // Send to server for validation and saving
        fetch(`https://${RESOURCE_NAME}/NUI:Client:InventoryClose`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            playerInventory: compressedPlayer,
            externalInventory: compressedExternal,
            externalNetId: externalNetId.value
          })
        }).catch(err => {
          console.error('Error closing inventory:', err)
        })
      }

      // Clear state
      isVisible.value = false
      externalInventory.value = []
      playerInventory.value = []
      externalNetId.value = null
    }

    /**
     * Start dragging the inventory window
     */
    const startDrag = (event) => {
      if (event.button !== 0) return // Only left mouse button
      
      isDragging.value = true
      dragOffset.value = {
        x: event.clientX - position.value.x,
        y: event.clientY - position.value.y
      }
      
      document.addEventListener('mousemove', onDrag)
      document.addEventListener('mouseup', stopDrag)
      event.preventDefault()
    }
    
    /**
     * Handle dragging motion
     */
    const onDrag = (event) => {
      if (!isDragging.value) return
      
      position.value = {
        x: event.clientX - dragOffset.value.x,
        y: event.clientY - dragOffset.value.y
      }
    }
    
    /**
     * Stop dragging and save position
     */
    const stopDrag = () => {
      if (isDragging.value) {
        isDragging.value = false
        saveWindowPosition()
        document.removeEventListener('mousemove', onDrag)
        document.removeEventListener('mouseup', stopDrag)
      }
    }
    
    /**
     * Handle ESC key to close inventory
     */
    const handleKeydown = (event) => {
      if (event.key === 'Escape' && (isVisible.value || isLoading.value || hasTimeout.value)) {
        isVisible.value = false
        isLoading.value = false
        hasTimeout.value = false
        closeInventory()
      }
    }

    onMounted(() => {
      window.addEventListener('message', handleMessage)
      window.addEventListener('keydown', handleKeydown)
      loadWindowPosition()
    })

    onUnmounted(() => {
      window.removeEventListener('message', handleMessage)
      window.removeEventListener('keydown', handleKeydown)
      stopDrag()
    })

    return {
      isVisible,
      isLoading,
      hasTimeout,
      loadingTitle,
      timeoutMessage,
      isDualMode,
      externalTitle,
      externalInventory,
      playerInventory,
      externalMaxSlots,
      playerMaxSlots,
      inventoryWrapper,
      wrapperStyle,
      updateExternalInventory,
      updatePlayerInventory,
      handleItemAction,
      startDrag,
      closeInventory
    }
  }
}
</script>

<style scoped>
.inventory-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(5px);
  z-index: 1000;
  pointer-events: none;
}

.inventory-wrapper {
  position: relative;
  display: flex;
  flex-direction: column;
  background: rgba(15, 15, 15, 0.98);
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  overflow: hidden;
  max-width: 90vw;
  max-height: 90vh;
  box-shadow: 0 10px 50px rgba(0, 0, 0, 0.8);
  pointer-events: auto;
  transition: transform 0.1s ease-out;
}

.drag-handle {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 20px;
  background: rgba(30, 30, 30, 0.95);
  border-bottom: 2px solid rgba(255, 255, 255, 0.1);
  cursor: grab;
  user-select: none;
}

.drag-handle:active {
  cursor: grabbing;
}

.drag-indicator {
  font-size: 1.2rem;
  color: rgba(255, 255, 255, 0.4);
  margin-right: 10px;
}

.drag-text {
  flex: 1;
  color: #fff;
  font-size: 1.1rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.close-button {
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  font-size: 1.5rem;
  cursor: pointer;
  padding: 0 8px;
  transition: all 0.2s ease;
  line-height: 1;
}

.close-button:hover {
  color: #ff4444;
  transform: scale(1.1);
}

.inventory-panels {
  display: flex;
  gap: 20px;
  padding: 20px;
  overflow: auto;
}

/* Box opening animation */
.box-open-enter-active {
  animation: boxOpen 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.box-open-leave-active {
  animation: boxClose 0.4s cubic-bezier(0.645, 0.045, 0.355, 1);
}

@keyframes boxOpen {
  0% {
    opacity: 0;
    transform: scale(0.3) rotateX(-90deg) rotateY(0deg);
    transform-origin: center center;
  }
  50% {
    opacity: 1;
    transform: scale(1.05) rotateX(0deg) rotateY(0deg);
  }
  100% {
    opacity: 1;
    transform: scale(1) rotateX(0deg) rotateY(0deg);
  }
}

@keyframes boxClose {
  0% {
    opacity: 1;
    transform: scale(1) rotateX(0deg) rotateY(0deg);
  }
  100% {
    opacity: 0;
    transform: scale(0.3) rotateX(90deg) rotateY(0deg);
  }
}

/* Loading Overlay */
.loading-overlay {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 20px;
  pointer-events: auto;
  background: rgba(15, 15, 15, 0.98);
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 60px 80px;
  box-shadow: 0 10px 50px rgba(0, 0, 0, 0.8);
}

.loading-spinner {
  width: 60px;
  height: 60px;
  border: 4px solid rgba(255, 255, 255, 0.1);
  border-top-color: #FFC107;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.loading-text {
  color: #fff;
  font-size: 1.1rem;
  font-weight: 500;
}

/* Timeout Overlay */
.timeout-overlay {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 15px;
  pointer-events: auto;
  background: rgba(15, 15, 15, 0.98);
  border: 2px solid rgba(255, 100, 100, 0.5);
  border-radius: 12px;
  padding: 40px 60px;
  box-shadow: 0 10px 50px rgba(0, 0, 0, 0.8);
  max-width: 500px;
  text-align: center;
}

.timeout-icon {
  font-size: 3rem;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.timeout-title {
  color: #ff4444;
  font-size: 1.5rem;
  font-weight: 700;
  margin: 0;
}

.timeout-message {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1rem;
  line-height: 1.5;
  margin: 10px 0;
}

.timeout-button {
  margin-top: 20px;
  padding: 12px 40px;
  background: rgba(255, 100, 100, 0.2);
  border: 2px solid rgba(255, 100, 100, 0.5);
  border-radius: 6px;
  color: #fff;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.timeout-button:hover {
  background: rgba(255, 100, 100, 0.3);
  border-color: rgba(255, 100, 100, 0.7);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 100, 100, 0.3);
}

.timeout-button:active {
  transform: translateY(0);
}
</style>
