<template>
  <div class="calculator-app">
    <div class="app-header">
      <h2>Calculator</h2>
    </div>
    
    <div class="calculator-content">
      <!-- Display -->
      <div class="calculator-display">
        <div class="display-previous">{{ previousValue }} {{ operator }}</div>
        <div class="display-current">{{ currentValue || '0' }}</div>
      </div>
      
      <!-- Buttons -->
      <div class="calculator-buttons">
        <!-- Row 1: Clear and Operations -->
        <button @click="clear" class="btn btn-function">C</button>
        <button @click="clearEntry" class="btn btn-function">CE</button>
        <button @click="backspace" class="btn btn-function">←</button>
        <button @click="setOperator('÷')" class="btn btn-operator">÷</button>
        
        <!-- Row 2: 7-9 and multiply -->
        <button @click="appendNumber('7')" class="btn btn-number">7</button>
        <button @click="appendNumber('8')" class="btn btn-number">8</button>
        <button @click="appendNumber('9')" class="btn btn-number">9</button>
        <button @click="setOperator('×')" class="btn btn-operator">×</button>
        
        <!-- Row 3: 4-6 and subtract -->
        <button @click="appendNumber('4')" class="btn btn-number">4</button>
        <button @click="appendNumber('5')" class="btn btn-number">5</button>
        <button @click="appendNumber('6')" class="btn btn-number">6</button>
        <button @click="setOperator('-')" class="btn btn-operator">-</button>
        
        <!-- Row 4: 1-3 and add -->
        <button @click="appendNumber('1')" class="btn btn-number">1</button>
        <button @click="appendNumber('2')" class="btn btn-number">2</button>
        <button @click="appendNumber('3')" class="btn btn-number">3</button>
        <button @click="setOperator('+')" class="btn btn-operator">+</button>
        
        <!-- Row 5: 0, decimal and equals -->
        <button @click="appendNumber('0')" class="btn btn-number btn-zero">0</button>
        <button @click="appendDecimal" class="btn btn-number">.</button>
        <button @click="calculate" class="btn btn-equals">=</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

// Calculator state
const currentValue = ref('')
const previousValue = ref('')
const operator = ref('')
const shouldResetDisplay = ref(false)

// Append number to display
const appendNumber = (num) => {
  if (shouldResetDisplay.value) {
    currentValue.value = num
    shouldResetDisplay.value = false
  } else {
    currentValue.value = currentValue.value + num
  }
}

// Append decimal point
const appendDecimal = () => {
  if (shouldResetDisplay.value) {
    currentValue.value = '0.'
    shouldResetDisplay.value = false
  } else if (!currentValue.value.includes('.')) {
    currentValue.value = (currentValue.value || '0') + '.'
  }
}

// Set operator
const setOperator = (op) => {
  if (currentValue.value === '' && previousValue.value === '') return
  
  if (previousValue.value !== '' && currentValue.value !== '') {
    calculate()
  }
  
  operator.value = op
  previousValue.value = currentValue.value || previousValue.value
  shouldResetDisplay.value = true
}

// Calculate result
const calculate = () => {
  if (previousValue.value === '' || currentValue.value === '' || operator.value === '') {
    return
  }
  
  const prev = parseFloat(previousValue.value)
  const current = parseFloat(currentValue.value)
  let result = 0
  
  switch (operator.value) {
    case '+':
      result = prev + current
      break
    case '-':
      result = prev - current
      break
    case '×':
      result = prev * current
      break
    case '÷':
      if (current === 0) {
        currentValue.value = 'Error'
        previousValue.value = ''
        operator.value = ''
        shouldResetDisplay.value = true
        return
      }
      result = prev / current
      break
    default:
      return
  }
  
  // Round to avoid floating point issues
  result = Math.round(result * 100000000) / 100000000
  
  currentValue.value = result.toString()
  previousValue.value = ''
  operator.value = ''
  shouldResetDisplay.value = true
}

// Clear all
const clear = () => {
  currentValue.value = ''
  previousValue.value = ''
  operator.value = ''
  shouldResetDisplay.value = false
}

// Clear entry
const clearEntry = () => {
  currentValue.value = ''
}

// Backspace
const backspace = () => {
  if (currentValue.value.length > 0) {
    currentValue.value = currentValue.value.slice(0, -1)
  }
}
</script>

<style scoped>
.calculator-app {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #1a1a1a;
}

.app-header {
  padding: 20px;
  background: rgba(255, 255, 255, 0.05);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.app-header h2 {
  margin: 0;
  color: white;
  font-size: 24px;
  font-weight: 600;
}

.calculator-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 20px;
}

/* Display */
.calculator-display {
  background: rgba(0, 0, 0, 0.4);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
  min-height: 100px;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.display-previous {
  color: rgba(255, 255, 255, 0.5);
  font-size: 18px;
  text-align: right;
  min-height: 24px;
  margin-bottom: 8px;
}

.display-current {
  color: white;
  font-size: 36px;
  font-weight: 300;
  text-align: right;
  word-break: break-all;
  font-family: 'Courier New', monospace;
}

/* Buttons */
.calculator-buttons {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  flex: 1;
}

.btn {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  color: white;
  font-size: 20px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  min-height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-2px);
}

.btn:active {
  transform: translateY(0);
}

.btn-number {
  background: rgba(255, 255, 255, 0.08);
}

.btn-number:hover {
  background: rgba(255, 255, 255, 0.12);
}

.btn-operator {
  background: rgba(102, 126, 234, 0.3);
  color: #a5b4fc;
}

.btn-operator:hover {
  background: rgba(102, 126, 234, 0.4);
}

.btn-function {
  background: rgba(239, 68, 68, 0.2);
  color: #fca5a5;
}

.btn-function:hover {
  background: rgba(239, 68, 68, 0.3);
}

.btn-equals {
  background: rgba(16, 185, 129, 0.3);
  color: #6ee7b7;
  grid-column: 4;
}

.btn-equals:hover {
  background: rgba(16, 185, 129, 0.4);
}

.btn-zero {
  grid-column: span 2;
}
</style>
