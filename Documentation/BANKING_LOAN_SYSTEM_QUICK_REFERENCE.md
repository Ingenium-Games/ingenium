# Banking Loan System - Quick Reference

## Files Modified

1. **`_config/config.lua`** - Added interest rate configuration
2. **`server/[SQL]/_bank.lua`** - Added 5 new SQL helper functions
3. **`server/_bank.lua`** - Implemented CalculateInterest() and CalculatePayments()

## Key Features

### Automatic Interest Calculation
- Runs daily at configured time (default: 3:00 PM)
- Applies percentage interest to all active loans
- Logs transactions to history
- Notifies online players

### Automatic Loan Payments
- Runs daily at configured time (default: 12:00 PM)
- Deducts 10% of loan from player's bank balance
- Handles insufficient funds gracefully
- Logs all transactions
- Credits bank job account
- Notifies online players

### Transaction Logging
All transactions recorded in `banking_transactions` table:
- Interest charges
- Successful payments
- Failed payment attempts

## Configuration

```lua
-- Interest rate (percentage)
conf.interestrate = 5

-- Payment time (12:00 PM)
conf.loanpayment = {h = 12, m = 0}

-- Interest calculation time (3:00 PM)
conf.loaninterest = {h = 15, m = 0}
```

## SQL Helper Functions

| Function | Purpose |
|----------|---------|
| `GetAllLoansEnabled()` | Get all accounts with active loans |
| `ProcessLoanInterest()` | Apply interest to loans |
| `ProcessLoanPayment()` | Deduct payment from bank/loan |
| `GetAccountsWithNegativeBalance()` | Find accounts in negative |
| `CheckAndFinalizeLoan()` | Mark loan as inactive when paid off |

## Transaction Types

| Type | Description |
|------|-------------|
| Interest Charge | Daily interest applied |
| Loan Payment | Successful automatic payment |
| Loan Payment Failed | Insufficient funds for payment |

## Player Notifications

Players receive in-game notifications for:
- Daily interest charges (warning)
- Successful payments (info)
- Failed payment attempts (error)

All notifications include:
- Transaction details
- Current balances
- Timestamps (via transaction log)
