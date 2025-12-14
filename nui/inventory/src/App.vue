<template>
  <div v-if="isVisible" class="inventory-container">
    <div class="inventory-wrapper">
      <!-- Left Panel - External Storage/Object -->
      <InventoryPanel
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
</template>

<script>
import { ref, onMounted, onUnmounted } from 'vue'
import InventoryPanel from './components/InventoryPanel.vue'

// Configuration constants
const RESOURCE_NAME = 'ig.core'  // Can be changed if resource is renamed

export default {
  name: 'App',
  components: {
    InventoryPanel
  },
  setup() {
    const isVisible = ref(false)
    const externalTitle = ref('Storage')
    const externalInventory = ref([])
    const playerInventory = ref([])
    const externalMaxSlots = ref(50)
    const playerMaxSlots = ref(50)
    const externalNetId = ref(null)

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
     * Handle NUI message events from FiveM
     */
    const handleMessage = (event) => {
      const { message, data } = event.data

      switch (message) {
        case 'openInventory':
          // Open dual-panel inventory
          isVisible.value = true
          externalTitle.value = data.externalTitle || 'Storage'
          externalNetId.value = data.externalNetId
          
          // Merge server inventory with saved positions
          playerInventory.value = mergeInventoryWithPositions(
            data.playerInventory || [],
            loadInventoryPositions('player')
          )
          externalInventory.value = mergeInventoryWithPositions(
            data.externalInventory || [],
            loadInventoryPositions(`external_${data.externalNetId}`)
          )
          
          playerMaxSlots.value = data.playerMaxSlots || 50
          externalMaxSlots.value = data.externalMaxSlots || 50
          break

        case 'openSingleInventory':
          // Open single-panel inventory (player only)
          isVisible.value = true
          externalTitle.value = ''
          externalNetId.value = null
          
          playerInventory.value = mergeInventoryWithPositions(
            data.playerInventory || [],
            loadInventoryPositions('player')
          )
          externalInventory.value = []
          
          playerMaxSlots.value = data.playerMaxSlots || 50
          externalMaxSlots.value = 0
          break

        case 'closeInventory':
          isVisible.value = false
          closeInventory()
          break

        case 'updateInventory':
          // Update inventory from server
          if (data.playerInventory) {
            playerInventory.value = mergeInventoryWithPositions(
              data.playerInventory,
              loadInventoryPositions('player')
            )
          }
          if (data.externalInventory) {
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
      fetch(`https://${RESOURCE_NAME}/inventory_action`, {
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
      // Compress inventory arrays (remove empty slots for server transmission)
      const compressedPlayer = playerInventory.value.filter(item => item != null)
      const compressedExternal = externalInventory.value.filter(item => item != null)

      // Send to server for validation and saving
      fetch(`https://${RESOURCE_NAME}/inventory_close`, {
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

      // Clear state
      externalInventory.value = []
      playerInventory.value = []
      externalNetId.value = null
    }

    /**
     * Handle ESC key to close inventory
     */
    const handleKeydown = (event) => {
      if (event.key === 'Escape' && isVisible.value) {
        isVisible.value = false
        closeInventory()
      }
    }

    onMounted(() => {
      window.addEventListener('message', handleMessage)
      window.addEventListener('keydown', handleKeydown)
    })

    onUnmounted(() => {
      window.removeEventListener('message', handleMessage)
      window.removeEventListener('keydown', handleKeydown)
    })

    return {
      isVisible,
      externalTitle,
      externalInventory,
      playerInventory,
      externalMaxSlots,
      playerMaxSlots,
      updateExternalInventory,
      updatePlayerInventory,
      handleItemAction
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
}

.inventory-wrapper {
  display: flex;
  gap: 20px;
  max-width: 90vw;
  max-height: 90vh;
}
</style>
