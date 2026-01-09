import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useBankingStore = defineStore('banking', () => {
  // Visibility state
  const isVisible = ref(false)
  
  // Account data
  const accountData = ref({
    characterName: '',
    iban: '',
    balance: 0,
    cash: 0
  })
  
  // Transaction history
  const transactions = ref([])
  
  // Favorites
  const favorites = ref([])
  
  // Active tab
  const activeTab = ref('account') // 'account', 'transfer', 'withdraw', 'deposit', 'favorites'
  
  // Transfer form
  const transferForm = ref({
    targetIban: '',
    amount: '',
    description: ''
  })
  
  // Withdrawal form
  const withdrawalForm = ref({
    amount: ''
  })
  
  // Deposit form
  const depositForm = ref({
    amount: ''
  })
  
  // Computed
  const formattedBalance = computed(() => {
    return `$${accountData.value.balance.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
  })
  
  const formattedCash = computed(() => {
    return `$${accountData.value.cash.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
  })
  
  // Actions
  function open(data) {
    accountData.value = {
      characterName: data.characterName || '',
      iban: data.iban || '',
      balance: data.balance || 0,
      cash: data.cash || 0
    }
    
    transactions.value = data.transactions || []
    favorites.value = data.favorites || []
    activeTab.value = 'account'
    isVisible.value = true
  }
  
  function close() {
    isVisible.value = false
    resetForms()
  }
  
  function setActiveTab(tab) {
    activeTab.value = tab
    resetForms()
  }
  
  function resetForms() {
    transferForm.value = {
      targetIban: '',
      amount: '',
      description: ''
    }
    
    withdrawalForm.value = {
      amount: ''
    }
    
    depositForm.value = {
      amount: ''
    }
  }
  
  function updateBalance(balance) {
    accountData.value.balance = balance
  }
  
  function updateCash(cash) {
    accountData.value.cash = cash
  }
  
  function addTransaction(transaction) {
    transactions.value.unshift(transaction)
    // Keep only last 50 transactions
    if (transactions.value.length > 50) {
      transactions.value = transactions.value.slice(0, 50)
    }
  }
  
  function addFavorite(favorite) {
    if (!favorites.value.find(f => f.iban === favorite.iban)) {
      favorites.value.push(favorite)
    }
  }
  
  function removeFavorite(iban) {
    favorites.value = favorites.value.filter(f => f.iban !== iban)
  }
  
  function setTransferTarget(iban, name) {
    transferForm.value.targetIban = iban
    activeTab.value = 'transfer'
  }
  
  return {
    // State
    isVisible,
    accountData,
    transactions,
    favorites,
    activeTab,
    transferForm,
    withdrawalForm,
    depositForm,
    
    // Computed
    formattedBalance,
    formattedCash,
    
    // Actions
    open,
    close,
    setActiveTab,
    resetForms,
    updateBalance,
    updateCash,
    addTransaction,
    addFavorite,
    removeFavorite,
    setTransferTarget
  }
})
