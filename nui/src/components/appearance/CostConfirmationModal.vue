<template>
  <Transition name="modal">
    <div v-if="appearanceStore.showCostConfirmation" class="modal-overlay" @click.self="handleCancel">
      <div class="modal-container">
        <div class="modal-header">
          <h3 class="modal-title">Confirm Purchase</h3>
          <button @click="handleCancel" class="close-btn" aria-label="Close">&times;</button>
        </div>
        
        <div class="modal-body">
          <p class="modal-description">
            You are about to purchase the following appearance changes:
          </p>
          
          <div v-if="appearanceStore.itemizedCosts.length > 0" class="itemized-list">
            <div
              v-for="(item, index) in appearanceStore.itemizedCosts"
              :key="index"
              class="cost-item"
            >
              <span class="item-description">{{ item.description }}</span>
              <span class="item-price">{{ formatCurrency(item.price) }}</span>
            </div>
          </div>
          
          <div class="total-cost">
            <span class="total-label">Total Cost:</span>
            <span class="total-amount">{{ formatCurrency(appearanceStore.currentCost) }}</span>
          </div>
          
          <p v-if="hasDiscount" class="discount-notice">
            * Employee discount applied
          </p>
        </div>
        
        <div class="modal-footer">
          <button
            @click="handleCancel"
            class="modal-btn cancel-btn"
            :disabled="appearanceStore.isLoading"
          >
            Cancel
          </button>
          <button
            @click="handleConfirm"
            class="modal-btn confirm-btn"
            :disabled="appearanceStore.isLoading"
          >
            <span v-if="!appearanceStore.isLoading">Confirm Purchase</span>
            <span v-else>Processing...</span>
          </button>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { computed } from 'vue'
import { useAppearanceStore } from '../../stores/appearance'
import { formatCurrency } from '../../utils/currency'

const appearanceStore = useAppearanceStore()

const hasDiscount = computed(() => {
  return appearanceStore.pricing?.modifiers?.employee_discount && 
         appearanceStore.pricing.modifiers.employee_discount < 1
})

function handleConfirm() {
  appearanceStore.confirmPurchase()
}

function handleCancel() {
  appearanceStore.cancelPurchase()
}
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active .modal-container,
.modal-leave-active .modal-container {
  transition: transform 0.3s;
}

.modal-enter-from .modal-container,
.modal-leave-to .modal-container {
  transform: scale(0.9);
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 3000;
  padding: 20px;
}

.modal-container {
  background: linear-gradient(135deg, rgba(26, 26, 26, 0.98), rgba(42, 42, 42, 0.98));
  border-radius: 12px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  width: 100%;
  max-width: 500px;
  overflow: hidden;
}

.modal-header {
  padding: 20px 24px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-title {
  font-size: 20px;
  font-weight: 700;
  color: white;
  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.5);
  font-size: 28px;
  cursor: pointer;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.2s;
}

.close-btn:hover {
  color: white;
}

.modal-body {
  padding: 24px;
}

.modal-description {
  color: rgba(255, 255, 255, 0.7);
  margin: 0 0 20px 0;
  font-size: 14px;
}

.itemized-list {
  background: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 16px;
  max-height: 300px;
  overflow-y: auto;
}

.itemized-list::-webkit-scrollbar {
  width: 6px;
}

.itemized-list::-webkit-scrollbar-track {
  background: rgba(42, 42, 42, 0.5);
  border-radius: 3px;
}

.itemized-list::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.cost-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  color: rgba(255, 255, 255, 0.8);
  font-size: 14px;
}

.cost-item:not(:last-child) {
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.item-description {
  flex: 1;
}

.item-price {
  font-weight: 600;
  color: #4287f5;
}

.total-cost {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background: rgba(66, 135, 245, 0.1);
  border-radius: 8px;
  border: 1px solid rgba(66, 135, 245, 0.3);
}

.total-label {
  font-size: 16px;
  font-weight: 600;
  color: white;
}

.total-amount {
  font-size: 20px;
  font-weight: 700;
  color: #4287f5;
}

.discount-notice {
  margin: 12px 0 0 0;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  font-style: italic;
}

.modal-footer {
  padding: 16px 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.modal-btn {
  padding: 10px 24px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  min-width: 120px;
}

.modal-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.cancel-btn {
  background: rgba(108, 117, 125, 0.2);
  border: 1px solid rgba(108, 117, 125, 0.4);
  color: #adb5bd;
}

.cancel-btn:hover:not(:disabled) {
  background: rgba(108, 117, 125, 0.3);
  border-color: rgba(108, 117, 125, 0.6);
  color: #dee2e6;
}

.confirm-btn {
  background: rgba(66, 135, 245, 0.2);
  border: 1px solid rgba(66, 135, 245, 0.4);
  color: #4287f5;
}

.confirm-btn:hover:not(:disabled) {
  background: rgba(66, 135, 245, 0.3);
  border-color: rgba(66, 135, 245, 0.6);
  transform: translateY(-1px);
}

.confirm-btn:active:not(:disabled) {
  transform: translateY(0);
}
</style>
