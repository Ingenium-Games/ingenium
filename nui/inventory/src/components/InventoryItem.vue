<template>
  <div 
    v-if="item" 
    class="inventory-item" 
    :class="{ 'item-degraded': isDegraded }"
    @contextmenu.prevent="showContextMenu"
  >
    <div class="item-image">
      <img :src="itemImage" :alt="item.Name || item.Item" />
      <div v-if="item.Quality < 100" class="quality-bar">
        <div 
          class="quality-fill" 
          :style="{ width: item.Quality + '%', backgroundColor: qualityColor }"
        ></div>
      </div>
    </div>
    
    <div class="item-info">
      <div class="item-name">{{ item.Name || item.Item }}</div>
      <div v-if="item.Quantity > 1" class="item-quantity">x{{ item.Quantity }}</div>
    </div>

    <!-- Context Menu -->
    <div v-if="showMenu" class="context-menu" :style="menuPosition">
      <button @click="emitUse" class="menu-item">Use</button>
      <button @click="emitGive" class="menu-item">Give</button>
      <button @click="emitDrop" class="menu-item">Drop</button>
    </div>
  </div>
  
  <div v-else class="inventory-item empty">
    <div class="empty-slot"></div>
  </div>
</template>

<script>
import { ref, computed, onMounted, onUnmounted } from 'vue'

export default {
  name: 'InventoryItem',
  props: {
    item: {
      type: Object,
      default: null
    },
    index: {
      type: Number,
      required: true
    }
  },
  emits: ['use', 'give', 'drop'],
  setup(props, { emit }) {
    const showMenu = ref(false)
    const menuPosition = ref({})

    /**
     * Computed property for item image path
     */
    const itemImage = computed(() => {
      if (!props.item) return ''
      // Assuming images are stored in nui/img/ directory with item name
      return `../img/${props.item.Item}.png`
    })

    /**
     * Check if item is degraded (quality below threshold)
     */
    const isDegraded = computed(() => {
      return props.item && props.item.Quality < 50
    })

    /**
     * Get quality bar color based on quality percentage
     */
    const qualityColor = computed(() => {
      if (!props.item) return '#4CAF50'
      const quality = props.item.Quality
      
      if (quality >= 75) return '#4CAF50' // Green
      if (quality >= 50) return '#FFC107' // Yellow
      if (quality >= 25) return '#FF9800' // Orange
      return '#F44336' // Red
    })

    /**
     * Show context menu on right-click
     */
    const showContextMenu = (event) => {
      if (!props.item) return
      
      showMenu.value = true
      menuPosition.value = {
        top: `${event.offsetY}px`,
        left: `${event.offsetX}px`
      }
    }

    /**
     * Hide context menu on click outside
     */
    const hideContextMenu = () => {
      showMenu.value = false
    }

    /**
     * Emit use action
     */
    const emitUse = () => {
      emit('use')
      hideContextMenu()
    }

    /**
     * Emit give action
     */
    const emitGive = () => {
      emit('give')
      hideContextMenu()
    }

    /**
     * Emit drop action
     */
    const emitDrop = () => {
      emit('drop')
      hideContextMenu()
    }

    onMounted(() => {
      document.addEventListener('click', hideContextMenu)
    })

    onUnmounted(() => {
      document.removeEventListener('click', hideContextMenu)
    })

    return {
      showMenu,
      menuPosition,
      itemImage,
      isDegraded,
      qualityColor,
      showContextMenu,
      emitUse,
      emitGive,
      emitDrop
    }
  }
}
</script>

<style scoped>
.inventory-item {
  position: relative;
  background: rgba(40, 40, 40, 0.9);
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  padding: 8px;
  cursor: grab;
  transition: all 0.2s ease;
  aspect-ratio: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.inventory-item:hover {
  border-color: rgba(100, 150, 255, 0.5);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}

.inventory-item:active {
  cursor: grabbing;
}

.inventory-item.item-degraded {
  border-color: rgba(255, 100, 100, 0.3);
}

.inventory-item.empty {
  background: rgba(30, 30, 30, 0.5);
  border: 2px dashed rgba(255, 255, 255, 0.05);
  cursor: default;
}

.inventory-item.empty:hover {
  border-color: rgba(255, 255, 255, 0.05);
  transform: none;
  box-shadow: none;
}

.empty-slot {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  color: rgba(255, 255, 255, 0.1);
  font-size: 2rem;
}

.item-image {
  position: relative;
  width: 100%;
  height: 60%;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 5px;
}

.item-image img {
  max-width: 90%;
  max-height: 90%;
  object-fit: contain;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.5));
}

.quality-bar {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 2px;
  overflow: hidden;
}

.quality-fill {
  height: 100%;
  transition: width 0.3s ease, background-color 0.3s ease;
}

.item-info {
  width: 100%;
  text-align: center;
}

.item-name {
  color: #fff;
  font-size: 0.75rem;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.8);
}

.item-quantity {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.7rem;
  margin-top: 2px;
}

/* Context Menu */
.context-menu {
  position: absolute;
  background: rgba(20, 20, 20, 0.98);
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 6px;
  padding: 5px;
  z-index: 1000;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
  min-width: 100px;
}

.menu-item {
  display: block;
  width: 100%;
  padding: 8px 12px;
  background: transparent;
  border: none;
  color: #fff;
  text-align: left;
  cursor: pointer;
  font-size: 0.9rem;
  transition: background 0.2s ease;
  border-radius: 4px;
}

.menu-item:hover {
  background: rgba(100, 150, 255, 0.3);
}

.menu-item:active {
  background: rgba(100, 150, 255, 0.5);
}
</style>
