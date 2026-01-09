<template>
  <div v-if="bankingStore.isVisible" class="banking-container">
    <div class="banking-window">
      <!-- Header -->
      <div class="banking-header">
        <h2>Banking</h2>
        <button class="close-btn" @click="CloseBank">✕</button>
      </div>
      
      <!-- Account Info Bar -->
      <div class="account-info">
        <div class="info-item">
          <span class="info-label">Account Holder:</span>
          <span class="info-value">{{ bankingStore.accountData.characterName }}</span>
        </div>
        <div class="info-item">
          <span class="info-label">IBAN:</span>
          <span class="info-value">{{ bankingStore.accountData.iban }}</span>
        </div>
        <div class="info-item">
          <span class="info-label">Balance:</span>
          <span class="info-value balance">{{ bankingStore.formattedBalance }}</span>
        </div>
        <div class="info-item">
          <span class="info-label">Cash:</span>
          <span class="info-value cash">{{ bankingStore.formattedCash }}</span>
        </div>
      </div>
      
      <!-- Navigation Tabs -->
      <div class="banking-tabs">
        <button 
          :class="['tab-btn', { active: bankingStore.activeTab === 'account' }]"
          @click="bankingStore.setActiveTab('account')"
        >
          Account
        </button>
        <button 
          :class="['tab-btn', { active: bankingStore.activeTab === 'transfer' }]"
          @click="bankingStore.setActiveTab('transfer')"
        >
          Transfer
        </button>
        <button 
          :class="['tab-btn', { active: bankingStore.activeTab === 'withdraw' }]"
          @click="bankingStore.setActiveTab('withdraw')"
        >
          Withdraw
        </button>
        <button 
          :class="['tab-btn', { active: bankingStore.activeTab === 'deposit' }]"
          @click="bankingStore.setActiveTab('deposit')"
        >
          Deposit
        </button>
        <button 
          :class="['tab-btn', { active: bankingStore.activeTab === 'favorites' }]"
          @click="bankingStore.setActiveTab('favorites')"
        >
          Favorites
        </button>
      </div>
      
      <!-- Content Area -->
      <div class="banking-content">
        <!-- Account Tab -->
        <div v-if="bankingStore.activeTab === 'account'" class="tab-content">
          <h3>Recent Transactions</h3>
          <div class="transactions-list">
            <div 
              v-for="(transaction, index) in bankingStore.transactions" 
              :key="index"
              class="transaction-item"
            >
              <div class="transaction-info">
                <span class="transaction-type">{{ transaction.type }}</span>
                <span class="transaction-desc">{{ transaction.description }}</span>
                <span class="transaction-date">{{ FormatDate(transaction.date) }}</span>
              </div>
              <div 
                :class="['transaction-amount', transaction.amount >= 0 ? 'positive' : 'negative']"
              >
                {{ transaction.amount >= 0 ? '+' : '' }}${{ Math.abs(transaction.amount).toLocaleString('en-US', { minimumFractionDigits: 2 }) }}
              </div>
            </div>
            <div v-if="bankingStore.transactions.length === 0" class="no-transactions">
              No transactions yet
            </div>
          </div>
        </div>
        
        <!-- Transfer Tab -->
        <div v-if="bankingStore.activeTab === 'transfer'" class="tab-content">
          <h3>Transfer Money</h3>
          <form @submit.prevent="HandleTransfer" class="banking-form">
            <div class="form-group">
              <label>Target IBAN:</label>
              <input 
                v-model="bankingStore.transferForm.targetIban" 
                type="text" 
                placeholder="Enter IBAN (e.g., 123456789)"
                maxlength="9"
                required
              />
            </div>
            <div class="form-group">
              <label>Amount:</label>
              <input 
                v-model="bankingStore.transferForm.amount" 
                type="number" 
                step="0.01"
                min="0.01"
                placeholder="0.00"
                required
              />
            </div>
            <div class="form-group">
              <label>Description (Optional):</label>
              <input 
                v-model="bankingStore.transferForm.description" 
                type="text" 
                placeholder="Payment description"
                maxlength="100"
              />
            </div>
            <div class="form-actions">
              <button type="submit" class="btn-primary">Transfer</button>
              <button type="button" class="btn-secondary" @click="bankingStore.resetForms">Clear</button>
            </div>
          </form>
          
          <!-- Quick Favorites Access -->
          <div v-if="bankingStore.favorites.length > 0" class="quick-favorites">
            <h4>Quick Select from Favorites:</h4>
            <div class="favorites-quick">
              <button 
                v-for="favorite in bankingStore.favorites" 
                :key="favorite.iban"
                @click="SelectFavorite(favorite)"
                class="favorite-quick-btn"
              >
                {{ favorite.name }} ({{ favorite.iban }})
              </button>
            </div>
          </div>
        </div>
        
        <!-- Withdraw Tab -->
        <div v-if="bankingStore.activeTab === 'withdraw'" class="tab-content">
          <h3>Withdraw Cash</h3>
          <form @submit.prevent="HandleWithdrawal" class="banking-form">
            <div class="form-group">
              <label>Amount to Withdraw:</label>
              <input 
                v-model="bankingStore.withdrawalForm.amount" 
                type="number" 
                step="0.01"
                min="0.01"
                placeholder="0.00"
                required
              />
            </div>
            <div class="form-info">
              <p>Withdrawals are converted to cash items in your inventory.</p>
              <p>Available Balance: {{ bankingStore.formattedBalance }}</p>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn-primary">Withdraw</button>
              <button type="button" class="btn-secondary" @click="bankingStore.resetForms">Clear</button>
            </div>
          </form>
        </div>
        
        <!-- Deposit Tab -->
        <div v-if="bankingStore.activeTab === 'deposit'" class="tab-content">
          <h3>Deposit Cash</h3>
          <form @submit.prevent="HandleDeposit" class="banking-form">
            <div class="form-group">
              <label>Amount to Deposit:</label>
              <input 
                v-model="bankingStore.depositForm.amount" 
                type="number" 
                step="0.01"
                min="0.01"
                placeholder="0.00"
                required
              />
            </div>
            <div class="form-info">
              <p>Deposits take cash from your inventory and add it to your bank account.</p>
              <p>Available Cash: {{ bankingStore.formattedCash }}</p>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn-primary">Deposit</button>
              <button type="button" class="btn-secondary" @click="bankingStore.resetForms">Clear</button>
            </div>
          </form>
        </div>
        
        <!-- Favorites Tab -->
        <div v-if="bankingStore.activeTab === 'favorites'" class="tab-content">
          <h3>Saved Favorites</h3>
          <div class="favorites-list">
            <div 
              v-for="favorite in bankingStore.favorites" 
              :key="favorite.iban"
              class="favorite-item"
            >
              <div class="favorite-info">
                <span class="favorite-name">{{ favorite.name }}</span>
                <span class="favorite-iban">{{ favorite.iban }}</span>
              </div>
              <div class="favorite-actions">
                <button @click="UseFavorite(favorite)" class="btn-use">Use</button>
                <button @click="RemoveFavorite(favorite.iban)" class="btn-remove">Remove</button>
              </div>
            </div>
            <div v-if="bankingStore.favorites.length === 0" class="no-favorites">
              No favorites saved yet. Complete a transfer and save the recipient as a favorite!
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useBankingStore } from '../stores/banking'
import { sendNuiMessage } from '../utils/nui'

const bankingStore = useBankingStore()

/**
 * Close the banking menu
 */
function CloseBank() {
  sendNuiMessage('banking:close')
  bankingStore.close()
}

/**
 * Handle money transfer
 */
function HandleTransfer() {
  const { targetIban, amount, description } = bankingStore.transferForm
  
  if (!targetIban || !amount) {
    return
  }
  
  const parsedAmount = parseFloat(amount)
  if (isNaN(parsedAmount) || parsedAmount <= 0) {
    return
  }
  
  sendNuiMessage('banking:transfer', {
    targetIban,
    amount: parsedAmount,
    description: description || ''
  })
}

/**
 * Handle cash withdrawal
 */
function HandleWithdrawal() {
  const { amount } = bankingStore.withdrawalForm
  
  if (!amount) {
    return
  }
  
  const parsedAmount = parseFloat(amount)
  if (isNaN(parsedAmount) || parsedAmount <= 0) {
    return
  }
  
  sendNuiMessage('banking:withdraw', {
    amount: parsedAmount
  })
}

/**
 * Handle cash deposit
 */
function HandleDeposit() {
  const { amount } = bankingStore.depositForm
  
  if (!amount) {
    return
  }
  
  const parsedAmount = parseFloat(amount)
  if (isNaN(parsedAmount) || parsedAmount <= 0) {
    return
  }
  
  sendNuiMessage('banking:deposit', {
    amount: parsedAmount
  })
}

/**
 * Select a favorite for transfer
 */
function SelectFavorite(favorite) {
  bankingStore.setTransferTarget(favorite.iban, favorite.name)
}

/**
 * Use a favorite (switch to transfer tab with IBAN filled)
 */
function UseFavorite(favorite) {
  bankingStore.setTransferTarget(favorite.iban, favorite.name)
}

/**
 * Remove a favorite
 */
function RemoveFavorite(iban) {
  sendNuiMessage('banking:removeFavorite', { iban })
  bankingStore.removeFavorite(iban)
}

/**
 * Format date for display
 */
function FormatDate(dateString) {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', { 
    month: 'short', 
    day: 'numeric', 
    hour: '2-digit', 
    minute: '2-digit' 
  })
}
</script>

<style scoped>
.banking-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.7);
  z-index: 1000;
  pointer-events: all;
}

.banking-window {
  background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
  border-radius: 12px;
  width: 90%;
  max-width: 800px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.banking-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.banking-header h2 {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #fff;
}

.close-btn {
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid rgba(239, 68, 68, 0.5);
  color: #ef4444;
  width: 32px;
  height: 32px;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 18px;
}

.close-btn:hover {
  background: rgba(239, 68, 68, 0.3);
  transform: scale(1.05);
}

.account-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 16px;
  padding: 20px;
  background: rgba(0, 0, 0, 0.2);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-label {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.info-value {
  font-size: 16px;
  font-weight: 600;
  color: #fff;
}

.info-value.balance {
  color: #10b981;
}

.info-value.cash {
  color: #3b82f6;
}

.banking-tabs {
  display: flex;
  padding: 0 20px;
  gap: 8px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  background: rgba(0, 0, 0, 0.2);
}

.tab-btn {
  padding: 12px 24px;
  background: transparent;
  border: none;
  border-bottom: 2px solid transparent;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
  font-weight: 500;
}

.tab-btn:hover {
  color: rgba(255, 255, 255, 0.9);
  background: rgba(255, 255, 255, 0.05);
}

.tab-btn.active {
  color: #3b82f6;
  border-bottom-color: #3b82f6;
}

.banking-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.tab-content {
  animation: fadeIn 0.2s ease-in;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.tab-content h3 {
  margin: 0 0 20px 0;
  color: #fff;
  font-size: 20px;
  font-weight: 600;
}

.transactions-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.transaction-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.2s;
}

.transaction-item:hover {
  background: rgba(255, 255, 255, 0.08);
  transform: translateX(4px);
}

.transaction-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.transaction-type {
  font-size: 14px;
  font-weight: 600;
  color: #fff;
}

.transaction-desc {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

.transaction-date {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.4);
}

.transaction-amount {
  font-size: 18px;
  font-weight: 700;
}

.transaction-amount.positive {
  color: #10b981;
}

.transaction-amount.negative {
  color: #ef4444;
}

.no-transactions,
.no-favorites {
  text-align: center;
  padding: 40px;
  color: rgba(255, 255, 255, 0.5);
  font-style: italic;
}

.banking-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-width: 500px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-size: 14px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
}

.form-group input {
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  color: #fff;
  font-size: 14px;
  transition: all 0.2s;
}

.form-group input:focus {
  outline: none;
  border-color: #3b82f6;
  background: rgba(255, 255, 255, 0.08);
}

.form-info {
  padding: 12px;
  background: rgba(59, 130, 246, 0.1);
  border: 1px solid rgba(59, 130, 246, 0.3);
  border-radius: 8px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 13px;
}

.form-info p {
  margin: 4px 0;
}

.form-actions {
  display: flex;
  gap: 12px;
}

.btn-primary,
.btn-secondary,
.btn-use,
.btn-remove {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background: #3b82f6;
  color: #fff;
  flex: 1;
}

.btn-primary:hover {
  background: #2563eb;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.8);
  flex: 1;
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.15);
}

.quick-favorites {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.quick-favorites h4 {
  margin: 0 0 12px 0;
  color: rgba(255, 255, 255, 0.8);
  font-size: 14px;
  font-weight: 500;
}

.favorites-quick {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.favorite-quick-btn {
  padding: 8px 16px;
  background: rgba(139, 92, 246, 0.2);
  border: 1px solid rgba(139, 92, 246, 0.4);
  border-radius: 6px;
  color: #a78bfa;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}

.favorite-quick-btn:hover {
  background: rgba(139, 92, 246, 0.3);
  transform: translateY(-2px);
}

.favorites-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.favorite-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.2s;
}

.favorite-item:hover {
  background: rgba(255, 255, 255, 0.08);
}

.favorite-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.favorite-name {
  font-size: 16px;
  font-weight: 600;
  color: #fff;
}

.favorite-iban {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
}

.favorite-actions {
  display: flex;
  gap: 8px;
}

.btn-use {
  background: rgba(16, 185, 129, 0.2);
  border: 1px solid rgba(16, 185, 129, 0.4);
  color: #10b981;
  padding: 8px 16px;
}

.btn-use:hover {
  background: rgba(16, 185, 129, 0.3);
  transform: translateY(-2px);
}

.btn-remove {
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid rgba(239, 68, 68, 0.4);
  color: #ef4444;
  padding: 8px 16px;
}

.btn-remove:hover {
  background: rgba(239, 68, 68, 0.3);
  transform: translateY(-2px);
}

/* Scrollbar styling */
.banking-content::-webkit-scrollbar {
  width: 8px;
}

.banking-content::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.2);
}

.banking-content::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
}

.banking-content::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>
