import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useJobStore = defineStore('job', () => {
  // Visibility state
  const isVisible = ref(false)
  
  // Job data
  const jobData = ref({
    name: '',
    label: '',
    description: '',
    boss: '', // Character ID of owner/boss
    grades: [],
    members: [],
    accounts: {
      safe: 0,
      bank: 0
    },
    inventory: [],
    stock: [],
    prices: {},
    locations: {
      sales: [],
      delivery: [],
      safe: null
    },
    memos: [],
    settings: {
      showFinancials: false, // Whether to show financials to employees
      allowEmployeeActions: true
    }
  })
  
  // User info (current player)
  const userInfo = ref({
    characterId: '',
    characterName: '',
    jobName: '',
    jobGrade: 0,
    isBoss: false
  })
  
  // Active tab
  const activeTab = ref('overview') // 'overview', 'employees', 'locations', 'prices', 'financials', 'memos'
  
  // Financial data
  const financialData = ref({
    income: [],
    expenses: [],
    totalIncome: 0,
    totalExpenses: 0,
    netProfit: 0
  })
  
  // Employee list (for bosses)
  const employees = ref([])
  
  // Computed
  const formattedSafe = computed(() => {
    return `$${jobData.value.accounts.safe.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
  })
  
  const formattedBank = computed(() => {
    return `$${jobData.value.accounts.bank.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
  })
  
  const availableTabs = computed(() => {
    const tabs = [{ id: 'overview', label: 'Overview' }]
    
    if (userInfo.value.isBoss) {
      tabs.push(
        { id: 'employees', label: 'Employees' },
        { id: 'locations', label: 'Locations' },
        { id: 'prices', label: 'Pricing' },
        { id: 'financials', label: 'Financials' },
        { id: 'memos', label: 'Memos' }
      )
    } else {
      // Regular employees
      if (jobData.value.settings.showFinancials) {
        tabs.push({ id: 'financials', label: 'Financials' })
      }
      
      tabs.push({ id: 'memos', label: 'Memos' })
      
      if (jobData.value.settings.allowEmployeeActions) {
        // Add any employee-specific tabs here
      }
    }
    
    return tabs
  })
  
  const gradeName = computed(() => {
    if (!jobData.value.grades || !userInfo.value.jobGrade) {
      return 'Unknown'
    }
    
    const grade = jobData.value.grades.find(g => g.rank === userInfo.value.jobGrade)
    return grade ? grade.name : 'Unknown'
  })
  
  // Actions
  function open(data) {
    console.log('[JobStore] Opening job menu with data:', data)
    
    // Set job data
    jobData.value = {
      name: data.job?.name || '',
      label: data.job?.label || '',
      description: data.job?.description || '',
      boss: data.job?.boss || '',
      grades: data.job?.grades || [],
      members: data.job?.members || [],
      accounts: data.job?.accounts || { safe: 0, bank: 0 },
      inventory: data.job?.inventory || [],
      stock: data.job?.stock || [],
      prices: data.job?.prices || {},
      locations: data.job?.locations || { sales: [], delivery: [], safe: null },
      memos: data.job?.memos || [],
      settings: data.job?.settings || {
        showFinancials: false,
        allowEmployeeActions: true
      }
    }
    
    // Set user info
    userInfo.value = {
      characterId: data.user?.characterId || '',
      characterName: data.user?.characterName || '',
      jobName: data.user?.jobName || '',
      jobGrade: data.user?.jobGrade || 0,
      isBoss: data.user?.isBoss || false
    }
    
    // Set financial data if provided
    if (data.financials) {
      financialData.value = data.financials
    }
    
    // Set employees if provided
    if (data.employees) {
      employees.value = data.employees
    }
    
    // Set initial tab
    activeTab.value = 'overview'
    isVisible.value = true
  }
  
  function close() {
    isVisible.value = false
    resetState()
  }
  
  function setActiveTab(tab) {
    activeTab.value = tab
  }
  
  function resetState() {
    activeTab.value = 'overview'
    jobData.value = {
      name: '',
      label: '',
      description: '',
      boss: '',
      grades: [],
      members: [],
      accounts: { safe: 0, bank: 0 },
      inventory: [],
      stock: [],
      prices: {},
      locations: { sales: [], delivery: [], safe: null },
      memos: [],
      settings: {
        showFinancials: false,
        allowEmployeeActions: true
      }
    }
    userInfo.value = {
      characterId: '',
      characterName: '',
      jobName: '',
      jobGrade: 0,
      isBoss: false
    }
    financialData.value = {
      income: [],
      expenses: [],
      totalIncome: 0,
      totalExpenses: 0,
      netProfit: 0
    }
    employees.value = []
  }
  
  function updateAccounts(accounts) {
    jobData.value.accounts = accounts
  }
  
  function updateMemos(memos) {
    jobData.value.memos = memos
  }
  
  function updateEmployees(employeeList) {
    employees.value = employeeList
  }
  
  function updatePrices(prices) {
    jobData.value.prices = prices
  }
  
  function updateLocations(locations) {
    jobData.value.locations = locations
  }
  
  function updateFinancials(financials) {
    financialData.value = financials
  }
  
  return {
    // State
    isVisible,
    jobData,
    userInfo,
    activeTab,
    financialData,
    employees,
    
    // Computed
    formattedSafe,
    formattedBank,
    availableTabs,
    gradeName,
    
    // Actions
    open,
    close,
    setActiveTab,
    resetState,
    updateAccounts,
    updateMemos,
    updateEmployees,
    updatePrices,
    updateLocations,
    updateFinancials
  }
})
