<template>
  <div class="inventory-panel">
    <div class="panel-header">
      <h2>{{ title }}</h2>
      <div class="panel-info">
        <span>{{ usedSlots }} / {{ maxSlots }}</span>
      </div>
    </div>
    
    <div class="panel-content">
      <draggable
        v-model="localItems"
        :group="{ name: 'inventory', pull: true, put: true }"
        :animation="200"
        ghost-class="ghost"
        drag-class="drag"
        item-key="index"
        class="inventory-grid"
        @change="handleChange"
      >
        <template #item="{ element, index }">
          <InventoryItem
            :item="element"
            :index="index"
            @use="handleUse(element, index)"
            @give="handleGive(element, index)"
            @drop="handleDrop(element, index)"
          />
        </template>
      </draggable>
    </div>
  </div>
</template>

<script>
import { ref, computed, watch } from 'vue'
import draggable from 'vuedraggable'
import InventoryItem from './InventoryItem.vue'

export default {
  name: 'InventoryPanel',
  components: {
    draggable,
    InventoryItem
  },
  props: {
    title: {
      type: String,
      required: true
    },
    items: {
      type: Array,
      default: () => []
    },
    maxSlots: {
      type: Number,
      default: 50
    },
    panelId: {
      type: String,
      required: true
    }
  },
  emits: ['update-items', 'item-action'],
  setup(props, { emit }) {
    // Create local reactive copy of items with proper slot structure
    const localItems = ref([])

    /**
     * Initialize local items array with max slots
     */
    const initializeSlots = () => {
      const slots = new Array(props.maxSlots).fill(null)
      
      // Place existing items in their positions
      props.items.forEach((item, index) => {
        if (item && index < props.maxSlots) {
          slots[index] = item
        }
      })
      
      localItems.value = slots
    }

    /**
     * Computed property for number of used slots
     */
    const usedSlots = computed(() => {
      return localItems.value.filter(item => item != null).length
    })

    /**
     * Watch for external items changes
     */
    watch(() => props.items, () => {
      initializeSlots()
    }, { immediate: true, deep: true })

    /**
     * Watch for maxSlots changes
     */
    watch(() => props.maxSlots, () => {
      initializeSlots()
    })

    /**
     * Handle drag and drop changes
     */
    const handleChange = (evt) => {
      // Emit updated items to parent
      emit('update-items', [...localItems.value])
    }

    /**
     * Handle Use action
     */
    const handleUse = (item, position) => {
      emit('item-action', {
        action: 'use',
        item,
        position,
        panelId: props.panelId
      })
    }

    /**
     * Handle Give action
     */
    const handleGive = (item, position) => {
      emit('item-action', {
        action: 'give',
        item,
        position,
        panelId: props.panelId
      })
    }

    /**
     * Handle Drop action
     */
    const handleDrop = (item, position) => {
      emit('item-action', {
        action: 'drop',
        item,
        position,
        panelId: props.panelId
      })
    }

    return {
      localItems,
      usedSlots,
      handleChange,
      handleUse,
      handleGive,
      handleDrop
    }
  }
}
</script>

<style scoped>
.inventory-panel {
  background: rgba(20, 20, 20, 0.95);
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  padding: 20px;
  min-width: 500px;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 2px solid rgba(255, 255, 255, 0.1);
}

.panel-header h2 {
  color: #fff;
  font-size: 1.5rem;
  margin: 0;
}

.panel-info {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.panel-content {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
}

.inventory-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
  gap: 10px;
  padding: 5px;
}

/* Custom scrollbar */
.panel-content::-webkit-scrollbar {
  width: 8px;
}

.panel-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 4px;
}

.panel-content::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
}

.panel-content::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}

/* Drag and drop ghost styles */
.ghost {
  opacity: 0.5;
  background: rgba(100, 100, 255, 0.3);
  border: 2px dashed rgba(255, 255, 255, 0.5);
}

.drag {
  opacity: 0.8;
  transform: scale(1.05);
}
</style>
