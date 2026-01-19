<template>
  <div class="financial-container">
    <div class="section-header">
      <h3 class="section-title">Financial Report</h3>
      <p class="section-desc">Income and expense overview</p>
    </div>
    
    <!-- Summary Cards -->
    <div class="summary-grid">
      <div class="summary-card income">
        <div class="card-icon">💰</div>
        <div class="card-content">
          <div class="card-label">Total Income</div>
          <div class="card-value">${{ formatNumber(jobStore.financialData.totalIncome) }}</div>
        </div>
      </div>
      
      <div class="summary-card expense">
        <div class="card-icon">📉</div>
        <div class="card-content">
          <div class="card-label">Total Expenses</div>
          <div class="card-value">${{ formatNumber(jobStore.financialData.totalExpenses) }}</div>
        </div>
      </div>
      
      <div class="summary-card profit" :class="{ negative: jobStore.financialData.netProfit < 0 }">
        <div class="card-icon">📊</div>
        <div class="card-content">
          <div class="card-label">Net Profit</div>
          <div class="card-value">${{ formatNumber(jobStore.financialData.netProfit) }}</div>
        </div>
      </div>
    </div>
    
    <!-- Income Transactions -->
    <div class="transaction-section">
      <h4 class="subsection-title">Recent Income</h4>
      <div v-if="jobStore.financialData.income.length === 0" class="empty-state">
        No income transactions recorded
      </div>
      <div v-else class="transaction-list">
        <div 
          v-for="(transaction, index) in jobStore.financialData.income.slice(0, 10)" 
          :key="`income-${index}`"
          class="transaction-item income"
        >
          <div class="transaction-info">
            <span class="transaction-desc">{{ transaction.description }}</span>
            <span class="transaction-date">{{ formatDate(transaction.date) }}</span>
          </div>
          <div class="transaction-amount positive">
            +${{ formatNumber(transaction.amount) }}
          </div>
        </div>
      </div>
    </div>
    
    <!-- Expense Transactions -->
    <div class="transaction-section">
      <h4 class="subsection-title">Recent Expenses</h4>
      <div v-if="jobStore.financialData.expenses.length === 0" class="empty-state">
        No expense transactions recorded
      </div>
      <div v-else class="transaction-list">
        <div 
          v-for="(transaction, index) in jobStore.financialData.expenses.slice(0, 10)" 
          :key="`expense-${index}`"
          class="transaction-item expense"
        >
          <div class="transaction-info">
            <span class="transaction-desc">{{ transaction.description }}</span>
            <span class="transaction-date">{{ formatDate(transaction.date) }}</span>
          </div>
          <div class="transaction-amount negative">
            -${{ formatNumber(transaction.amount) }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useJobStore } from '../../stores/job'

const jobStore = useJobStore()

function formatNumber(value) {
  return Math.abs(value).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
}

function formatDate(timestamp) {
  if (!timestamp) return 'Unknown'
  const date = new Date(timestamp)
  return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
}
</script>

<style scoped>
.financial-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.section-header {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: white;
  margin: 0;
}

.section-desc {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
  margin: 0;
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}

.summary-card {
  padding: 20px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 16px;
  transition: all 0.2s;
}

.summary-card.income {
  background: rgba(74, 222, 128, 0.1);
  border: 1px solid rgba(74, 222, 128, 0.3);
}

.summary-card.expense {
  background: rgba(251, 146, 60, 0.1);
  border: 1px solid rgba(251, 146, 60, 0.3);
}

.summary-card.profit {
  background: rgba(66, 135, 245, 0.1);
  border: 1px solid rgba(66, 135, 245, 0.3);
}

.summary-card.profit.negative {
  background: rgba(239, 68, 68, 0.1);
  border: 1px solid rgba(239, 68, 68, 0.3);
}

.summary-card:hover {
  transform: translateY(-2px);
}

.card-icon {
  font-size: 32px;
}

.card-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.card-label {
  font-size: 12px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.6);
  text-transform: uppercase;
}

.card-value {
  font-size: 24px;
  font-weight: 700;
  color: white;
}

.transaction-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.subsection-title {
  font-size: 16px;
  font-weight: 600;
  color: white;
  margin: 0;
  padding-bottom: 8px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.empty-state {
  padding: 30px 20px;
  text-align: center;
  color: rgba(255, 255, 255, 0.4);
  font-size: 13px;
  font-style: italic;
  background: rgba(26, 26, 26, 0.5);
  border: 1px dashed rgba(255, 255, 255, 0.1);
  border-radius: 6px;
}

.transaction-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.transaction-item {
  padding: 12px 16px;
  background: rgba(26, 26, 26, 0.5);
  border-radius: 6px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  transition: all 0.2s;
}

.transaction-item:hover {
  background: rgba(26, 26, 26, 0.7);
}

.transaction-item.income {
  border-left: 3px solid #4ade80;
}

.transaction-item.expense {
  border-left: 3px solid #fb923c;
}

.transaction-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.transaction-desc {
  font-size: 14px;
  font-weight: 600;
  color: white;
}

.transaction-date {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}

.transaction-amount {
  font-size: 16px;
  font-weight: 700;
  white-space: nowrap;
}

.transaction-amount.positive {
  color: #4ade80;
}

.transaction-amount.negative {
  color: #fb923c;
}

/* Responsive Design */
@media (max-width: 600px) {
  .summary-grid {
    grid-template-columns: 1fr;
  }
  
  .transaction-item {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .transaction-amount {
    align-self: flex-end;
  }
}
</style>
