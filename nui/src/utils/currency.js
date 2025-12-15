/**
 * Format a number as currency
 * @param {number} amount - The amount to format
 * @param {string} symbol - Currency symbol (default: '$')
 * @returns {string} Formatted currency string
 */
export function formatCurrency(amount, symbol = '$') {
  const formatted = Math.floor(amount).toLocaleString()
  return `${symbol}${formatted}`
}
