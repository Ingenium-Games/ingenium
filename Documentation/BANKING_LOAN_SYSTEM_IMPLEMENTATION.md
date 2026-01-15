# Banking Loan System Implementation

## Overview
This document describes the complete implementation of the automatic loan payment and interest calculation system for the Ingenium roleplay server.

---

## Configuration Changes

### File: `_config/config.lua`

Added interest rate configuration:
```lua
conf.interestrate = 5 -- Daily interest rate in percentage (5%)
```

**Existing Configurations Used:**
- `conf.loanpayment = {h = 12, m = 0}` - Time for automatic loan payments (12:00 PM)
- `conf.loaninterest = {h = 15, m = 0}` - Time for interest calculation (3:00 PM)
- `conf.bankoverdraw` - Fee charged for negative balance accounts

---

## Database Structure

### Table: `banking_accounts`
```sql
- Character_ID: Unique character identifier
- Bank: Current bank balance
- Loan: Outstanding loan amount
- Duration: Remaining loan duration (in days)
- Active: Boolean flag indicating if loan is active
```

### Table: `banking_transactions`
```sql
- Character_ID: Account owner
- Type: Transaction type (e.g., "Loan Payment", "Interest Charge")
- Description: Detailed description of transaction
- Amount: Transaction amount (negative for debits)
- Date: Transaction timestamp
```

---

## SQL Helper Functions

### File: `server/[SQL]/_bank.lua`

#### 1. `ig.sql.bank.GetAllLoansEnabled(cb)`
Retrieves all accounts with active loans.

**Returns:** Table of loan accounts with fields: `Character_ID`, `Bank`, `Loan`, `Duration`, `Active`

```lua
ig.sql.bank.GetAllLoansEnabled(function(loans)
    -- loans is a table of active loan accounts
end)
```

#### 2. `ig.sql.bank.ProcessLoanInterest(interestRate, cb)`
Applies daily interest to all active loans.

**Parameters:**
- `interestRate`: Percentage rate (e.g., 5 for 5%)
- `cb`: Callback function(affectedRows)

**SQL:** Multiplies loan amount by (1 + rate/100)

```lua
ig.sql.bank.ProcessLoanInterest(5, function(affectedRows)
    -- Interest applied to affectedRows accounts
end)
```

#### 3. `ig.sql.bank.ProcessLoanPayment(characterId, paymentAmount, cb)`
Deducts payment from bank balance and reduces loan amount.

**Parameters:**
- `characterId`: Character ID of borrower
- `paymentAmount`: Amount to deduct and apply to loan
- `cb`: Callback function(affectedRows)

**SQL:** 
- Reduces `Bank` by payment amount
- Reduces `Loan` by payment amount (minimum 0)

```lua
ig.sql.bank.ProcessLoanPayment(characterId, 100, function()
    -- Payment processed
end)
```

#### 4. `ig.sql.bank.GetAccountsWithNegativeBalance(cb)`
Retrieves accounts with negative bank balance.

**Returns:** Table of accounts with fields: `Character_ID`, `Bank`, `Loan`

#### 5. `ig.sql.bank.CheckAndFinalizeLoan(characterId, cb)`
Marks a loan as inactive when fully paid off.

**Parameters:**
- `characterId`: Character ID
- `cb`: Callback function(affectedRows)

---

## Main Functions

### File: `server/_bank.lua`

#### 1. `ig.bank.CalculateInterest()`

**Purpose:** Applies daily interest to all outstanding loans

**Scheduled Time:** Configured in `conf.loaninterest` (default: 3:00 PM)

**Process:**
1. Retrieves all active loans from database
2. Applies interest rate to each loan
3. Logs "Interest Charge" transaction for each account
4. Notifies online players of interest charges
5. Shows updated loan balance in notification

**Transaction Logging:**
```lua
Type: "Interest Charge"
Description: "Daily interest charge on outstanding loan (5%)"
Amount: -<interest_amount>
```

**Player Notification:**
```
Daily Loan Interest Applied
Interest Rate: 5%
Interest Charged: $<amount>
New Loan Balance: $<amount>
```

#### 2. `ig.bank.CalculatePayments()`

**Purpose:** Automatically deducts payments from bank balance to pay down loans

**Scheduled Time:** Configured in `conf.loanpayment` (default: 12:00 PM)

**Payment Calculation:** 10% of outstanding loan amount

**Process:**
1. Retrieves all active loans
2. For each account:
   - Calculates payment (10% of loan)
   - Checks if bank balance is sufficient
   - If sufficient:
     - Deducts payment from bank
     - Reduces loan amount
     - Logs "Loan Payment" transaction
     - Adds payment to bank job account
     - Notifies player if online
   - If insufficient:
     - Logs "Loan Payment Failed" transaction
     - Notifies player of failure
3. Reports totals in debug log

**Transaction Logging (Success):**
```lua
Type: "Loan Payment"
Description: "Automatic loan payment from bank account"
Amount: -<payment_amount>
```

**Transaction Logging (Failure):**
```lua
Type: "Loan Payment Failed"
Description: "Insufficient funds for automatic loan payment"
Amount: 0
```

**Player Notifications:**

Success:
```
Automatic Loan Payment
Amount Deducted: $<amount>
New Bank Balance: $<balance>
Remaining Loan: $<loan>
```

Failure:
```
Loan Payment Failed
Insufficient bank balance. Required: $<required>
Current Balance: $<current>
```

---

## Transaction Logging

All loan-related transactions are logged to `banking_transactions` table using:
```lua
ig.sql.banking.AddTransaction(characterId, {
    type = "Transaction Type",
    description = "Detailed description",
    amount = <signed_amount>
})
```

### Transaction Types Logged:
- **Interest Charge**: Daily interest applied
- **Loan Payment**: Successful automatic payment
- **Loan Payment Failed**: Failed payment attempt

---

## Player Notifications

Online players receive notifications via `Client:Notify` event with:
- Event Type: "warning" (interest), "info" (payment success), "error" (payment failure)
- Duration: 5000ms
- Detailed information about transaction and account balances

---

## Cron Job Configuration

Both functions are registered as cron jobs on server resource start:

```lua
-- Loan Payment Cron Job
AddEventHandler("onServerResourceStart", function()
    if not payments then
        ig.cron.RunAt(conf.loanpayment.h, conf.loanpayment.m, ig.bank.CalculatePayments)
        payments = true
    end
end)

-- Interest Calculation Cron Job
AddEventHandler("onServerResourceStart", function()
    if not interest then
        ig.cron.RunAt(conf.loaninterest.h, conf.loaninterest.m, ig.bank.CalculateInterest)
        interest = true
    end
end)
```

---

## Integration Notes

### Dependencies
- `ig.sql.bank.*` - SQL functions for bank operations
- `ig.sql.banking.*` - SQL functions for transaction logging
- `ig.data.GetJob()` - Retrieves job object
- `ig.data.GetPlayer()` - Retrieves player object by Character ID
- `ig.cron.RunAt()` - Cron job scheduling

### Job Account Updates
- Payment amounts are credited to the bank job account via `xJob.AddBank(paymentAmount)`
- This allows the bank to track collected payments

### Error Handling
- Functions check for nil values and empty result sets
- Missing job objects log debug messages but don't crash
- Insufficient funds are handled gracefully with failed payment logging

---

## Configuration Examples

### Conservative Loan System
```lua
conf.interestrate = 2          -- 2% daily interest
conf.loanpayment = {h = 18, m = 0}   -- Payments at 6:00 PM
conf.loaninterest = {h = 20, m = 0}  -- Interest at 8:00 PM
```

### Aggressive Loan System
```lua
conf.interestrate = 10         -- 10% daily interest
conf.loanpayment = {h = 12, m = 0}   -- Payments at noon
conf.loaninterest = {h = 13, m = 0}  -- Interest at 1:00 PM
```

---

## Testing Recommendations

1. **Create test accounts** with various loan amounts
2. **Monitor transactions** in the `banking_transactions` table
3. **Test insufficient funds** scenario
4. **Verify online notifications** display correctly
5. **Check job account** receives payment credits
6. **Monitor debug logs** for processing messages
7. **Test loan payoff** when loan reaches 0

---

## Future Enhancements

Possible improvements:
- Configurable payment amount (fixed or percentage)
- Late payment penalties
- Loan forgiveness after X duration
- Automated loan default enforcement
- Variable interest rates based on loan age
- Maximum loan limits per character
