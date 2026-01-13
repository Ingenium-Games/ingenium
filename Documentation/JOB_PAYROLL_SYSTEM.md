# Job Payroll System Documentation

## Overview

The Job Payroll System automatically processes employee payments every 30 minutes based on employment status, on-duty status, and minimum work time requirements. The system:

- **Deducts funds from job bank accounts** (no negative balance allowed)
- **Adds funds to individual player bank accounts** for successful payments
- **Tracks on-duty status** via statebag handlers and database
- **Enforces minimum work time** (default 20 minutes per payment cycle)
- **Logs all transactions** with success/failure status and reasons
- **Prevents payment if job account lacks funds** (with decline notification)

## Architecture

### Components

#### 1. Database Tables

**`job_payroll_tracking`** - Employee on-duty tracking
```sql
- Character_ID (FK to characters)
- Job (job name)
- On_Duty (boolean - current duty status)
- On_Duty_Start (timestamp - when went on duty)
- Last_Payment_Check (timestamp - last payment cycle)
```

**`banking_job_accounts`** - Job account balances (already existed)
```sql
- Job (job name)
- Bank (DECIMAL - current balance)
- Boss (Character_ID of owner)
```

**`banking_transactions`** - Transaction history
```sql
- Character_ID (receiving player)
- Type (set to "Payroll")
- Description (job name, status, reason if declined)
- Amount (payment amount or 0 if declined)
- Date (timestamp)
```

#### 2. SQL Layer (`server/[SQL]/_jobs.lua`)

All database operations abstracted through helper functions:

| Function | Purpose | Notes |
|---|---|---|
| `GetActiveDutyEmployees()` | Fetch on-duty employees for a job | Returns Character_ID, On_Duty_Start |
| `GetJobAccountBalance()` | Get job account current balance | Async callback |
| `ProcessPayment()` | Deduct from job account | Protected: no negative balance |
| `AddPaymentToPlayer()` | Add to player's personal bank | Via banking_accounts table |
| `LogPayrollTransaction()` | Record transaction to history | For audit trail |
| `SetPlayerDutyStatus()` | Update on-duty status in DB | Creates entry if not exists |
| `ProcessBulkPayments()` | Batch process multiple payments | Single queries for efficiency |

#### 3. Server Logic (`server/_payroll.lua`)

**Main Processing Function: `ig.payroll.ProcessPayroll()`**

Called every 30 minutes (via cron and timer):

```
1. Iterate through all configured jobs
2. For each job:
   a. Get all on-duty employees
   b. Validate minimum work time (20 minutes default)
   c. Check job account balance
   d. Process eligible payments or mark declined
   e. Send notifications to players
   f. Log all transactions
```

**Statebag Handler: `payroll:setDutyStatus`**

Triggered when player uses `/duty` command:
- Updates `job_payroll_tracking` table
- Sets `On_Duty` flag and `On_Duty_Start` timestamp
- Validates player is employed

**Payment Eligibility**

Payment processed if:
1. ✅ Player is on-duty
2. ✅ Player has worked ≥ 20 minutes since `On_Duty_Start`
3. ✅ Job account balance ≥ payment amount

If any condition fails:
- ❌ Payment declined
- ❌ Transaction logged with reason
- ❌ Player notified in chat

#### 4. Client Logic (`client/_payroll.lua`)

**Command: `/duty`**

Toggles on-duty status:
```
/duty -> Sets On_Duty = TRUE, On_Duty_Start = NOW()
/duty -> Sets On_Duty = FALSE (if already on-duty)
```

Triggers server event: `payroll:setDutyStatus`

**Exports**

```lua
exports('IsOnDuty')      -- Returns current duty status
exports('GetCurrentJob') -- Returns current job name
```

## Configuration

Located in `_config/config.lua`:

### Global Settings

```lua
conf.enablejobpayroll = true              -- Enable/disable entire system
conf.paycycle = conf.min * 30              -- Payment cycle (30 minutes)
conf.payrolltime = {h = 0, m = 0}          -- Cron start time
```

### Per-Job Configuration

```lua
conf.jobpayroll = {
    ['police'] = {
        enabled = true,
        payment_amount = 150.00,
        minimum_duty_minutes = 20
    },
    -- ... more jobs
}
```

**Parameters:**
- `enabled` - (boolean) Enable/disable payroll for this job
- `payment_amount` - (decimal) Amount paid per 30-minute cycle
- `minimum_duty_minutes` - (integer) Minimum on-duty time required for payment

## Payment Flow

### Successful Payment

```
Player goes on-duty via /duty
  ↓ (sets On_Duty_Start = NOW())
[Wait 20+ minutes]
  ↓
Every 30 minutes: ig.payroll.ProcessPayroll() runs
  ↓
Check: Does player meet all criteria?
  ✓ On-duty? Yes
  ✓ Worked 20+ minutes? Yes
  ✓ Job account has $150? Yes
  ↓
Banking_job_accounts: Bank -= 150.00
Banking_accounts: Bank += 150.00
Banking_transactions: Log successful payment
  ↓
Player notified: "You received $150.00 for your work at police"
```

### Declined Payment - Insufficient Work Time

```
Player goes on-duty via /duty
  ↓ (sets On_Duty_Start = NOW())
[Wait 5 minutes only]
  ↓
Every 30 minutes: ig.payroll.ProcessPayroll() runs
  ↓
Check: Worked 20+ minutes?
  ✗ Only 5 minutes worked
  ↓
Banking_transactions: Log declined with reason
  ↓
Player notified: "Payroll declined: Insufficient work time (5/20 minutes)"
```

### Declined Payment - Insufficient Job Funds

```
Police job account balance: $100.00
10 officers on-duty with $150 payment each = $1,500 needed
  ↓
Payroll processing runs:
  ✓ All officers eligible (worked 20+ minutes)
  ✗ Job account: $100 < $1,500 needed
  ↓
ALL payments marked "declined"
Banking_transactions: Log all declines with reason
  ↓
All officers notified: "Payroll declined: Job account insufficient funds"
```

## Batch Processing & Performance

### Optimization Strategies

1. **Batch SQL Updates**
   - Single `UPDATE` for job account deduction (total of all payments)
   - Individual `UPDATE` for each player's bank (can be parallelized)
   - All executed via `ig.sql.Batch()` in one round-trip

2. **Thread Breaks**
   - Process 25 employees per thread
   - 100ms break between batches
   - Prevents main thread blocking

3. **Example Performance**
   - 500 officers on-duty
   - Split into 20 batches of 25
   - ~2 seconds total processing time

### Pseudo-Code

```lua
for batchIdx = 0, numBatches - 1 do
    Citizen.CreateThread(function()
        -- Process 25 employees
        for i = startIdx, endIdx do
            ProcessPayment(employee)
        end
    end)
    Wait(100) -- Break between batches
end
```

## Database Queries

### Fetch On-Duty Employees

```sql
SELECT Character_ID, On_Duty_Start, Last_Payment_Check 
FROM job_payroll_tracking 
WHERE Job = 'police' AND On_Duty = TRUE
```

### Deduct from Job Account

```sql
UPDATE banking_job_accounts 
SET Bank = CASE 
    WHEN Bank >= ? THEN Bank - ?
    ELSE Bank
END
WHERE Job = ?
```

**Note:** `CASE` statement ensures balance never goes negative.

### Add to Player Bank

```sql
UPDATE banking_accounts 
SET Bank = Bank + ? 
WHERE Character_ID = ?
```

### Log Transaction

```sql
INSERT INTO banking_transactions 
(Character_ID, Type, Description, Amount, Date) 
VALUES (?, 'Payroll', ?, ?, NOW())
```

## Event Handlers

### Server Events

**`payroll:setDutyStatus`**

Triggered by client `/duty` command

Parameters:
- `jobName` (string) - Job name
- `onDuty` (boolean) - True for on-duty, false for off-duty

## Cron Job Registration

Payroll runs via two mechanisms:

### 1. Timer-Based (Active)

```lua
Citizen.CreateThread(function()
    while true do
        Wait(1800000) -- 30 minutes
        ig.payroll.ProcessPayroll()
    end
end)
```

### 2. Cron-Based (Optional)

```lua
-- Runs at every :00 and :30 of every hour
for h = 0, 23 do
    for m = 0, 59, 30 do
        ig.cron.RunAt({h = h, m = m}, function()
            ig.payroll.ProcessPayroll()
        end)
    end
end
```

## Notifications

### Player Notifications (Chat)

**Successful Payment**
```
[Payroll] You received $150.00 for your work at police
```

**Insufficient Work Time**
```
[Payroll] Payroll declined: Insufficient work time (5/20 minutes)
```

**Job Account Insufficient Funds**
```
[Payroll] Payroll declined: Job account insufficient funds
```

**Duty Status Changes**
```
[Payroll] You are now on-duty for police. You will receive payments every 30 minutes (min 20 min work time)
[Payroll] You are now off-duty. No payments will be received
```

## Testing

### Create Test Scenario

1. **Setup**
   ```sql
   -- Add $1000 to police job account
   UPDATE banking_job_accounts SET Bank = 1000.00 WHERE Job = 'police';
   
   -- Create test player (Character_ID = 'test')
   INSERT INTO job_payroll_tracking 
   (Character_ID, Job, On_Duty, On_Duty_Start) 
   VALUES ('test', 'police', TRUE, DATE_SUB(NOW(), INTERVAL 25 MINUTE));
   ```

2. **Run Payroll**
   ```lua
   -- In console:
   -- ig.payroll.ProcessPayroll()
   ```

3. **Verify Results**
   ```sql
   -- Check job account deducted
   SELECT Bank FROM banking_job_accounts WHERE Job = 'police';
   -- Should be 850.00 (1000 - 150)
   
   -- Check player received payment
   SELECT Bank FROM banking_accounts WHERE Character_ID = 'test';
   -- Should show increase of 150
   
   -- Check transaction logged
   SELECT * FROM banking_transactions 
   WHERE Character_ID = 'test' AND Type = 'Payroll'
   ORDER BY Date DESC LIMIT 1;
   ```

## SQL Migration

### For Existing Installations

```sql
-- Add job payroll tracking table
CREATE TABLE IF NOT EXISTS `job_payroll_tracking` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) NOT NULL,
  `Job` varchar(255) NOT NULL,
  `On_Duty` tinyint(1) NOT NULL DEFAULT 0,
  `On_Duty_Start` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Last_Payment_Check` timestamp NULL DEFAULT NULL,
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `unique_character_job` (`Character_ID`, `Job`),
  KEY `Job` (`Job`),
  KEY `On_Duty` (`On_Duty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Common Issues

### No Payments Processing

**Check List:**
1. ✓ Is `conf.enablejobpayroll = true`?
2. ✓ Is the job configured in `conf.jobpayroll`?
3. ✓ Is `enabled = true` for that job?
4. ✓ Is player actually on-duty? (`SELECT * FROM job_payroll_tracking WHERE On_Duty = TRUE`)
5. ✓ Has player worked 20+ minutes? (`SELECT TIMESTAMPDIFF(MINUTE, On_Duty_Start, NOW()) FROM job_payroll_tracking`)
6. ✓ Does job account have funds? (`SELECT Bank FROM banking_job_accounts WHERE Job = ?`)

### Players Not Going On-Duty

**Check List:**
1. ✓ Client-side script loaded (`client/_payroll.lua`)?
2. ✓ Server-side handler registered (`server/_payroll.lua`)?
3. ✓ Player employed in a valid job?
4. ✓ Check console for errors

### Payment Amounts Wrong

- Verify `payment_amount` in `conf.jobpayroll`
- Check if different job grades have different amounts (not currently supported - modify if needed)
- Verify `ig.math.Decimals()` rounding (should be 2 decimal places)

## Future Enhancements

1. **Grade-Based Payments** - Different payments per job rank
2. **Bonus Multipliers** - Extra pay for specific achievements
3. **Off-Duty Warning** - Notify player if off-duty
4. **Manual Adjustment** - Boss can adjust employee pay
5. **Tax Deduction** - Apply city tax to payroll
6. **Time Tracking** - Track total hours worked per period
7. **Performance Bonus** - Dynamic payments based on metrics

---

## Summary

The Job Payroll System provides a robust, scalable solution for automated employee payments with:

✅ Safety guardrails (no negative balances)
✅ Eligibility validation (20-minute minimum)
✅ Transaction auditing (complete history)
✅ Flexible configuration (per-job amounts)
✅ High performance (batch processing)
✅ Player notifications (clear feedback)
✅ Easy debugging (extensive logging)
