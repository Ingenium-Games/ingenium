# Job Payroll System - Implementation Guide

## Quick Start

### 1. Database Setup

Run this SQL to add the payroll tracking table:

```sql
CREATE TABLE IF NOT EXISTS `job_payroll_tracking` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Job` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `On_Duty` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Current on-duty status',
  `On_Duty_Start` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When player went on duty',
  `Last_Payment_Check` timestamp NULL DEFAULT NULL COMMENT 'Last payment processing time',
  `Created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY `unique_character_job` (`Character_ID`, `Job`) USING BTREE,
  KEY `Job` (`Job`) USING BTREE,
  KEY `On_Duty` (`On_Duty`) USING BTREE,
  KEY `On_Duty_Start` (`On_Duty_Start`) USING BTREE,
  CONSTRAINT `fk_payroll_character` FOREIGN KEY (`Character_ID`) REFERENCES `characters` (`Character_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tracks employee on-duty status and payroll eligibility';
```

### 2. Configuration

Edit `_config/config.lua` and set job payment amounts:

```lua
conf.enablejobpayroll = true

conf.jobpayroll = {
    ['police'] = {
        enabled = true,
        payment_amount = 150.00,
        minimum_duty_minutes = 20
    },
    ['fire'] = {
        enabled = true,
        payment_amount = 130.00,
        minimum_duty_minutes = 20
    },
    -- Add more jobs...
}
```

### 3. Files Included

| File | Purpose | 
|---|---|
| `server/[SQL]/_jobs.lua` | SQL helper functions for payroll |
| `server/_payroll.lua` | Main payroll processing logic |
| `client/_payroll.lua` | Client-side duty command |
| `db.sql` | Updated with job_payroll_tracking table |
| `_config/config.lua` | Job payroll configuration |

### 4. Enable in fxmanifest.lua

Ensure these files are loaded:

```lua
-- In fxmanifest.lua shared_scripts or client_scripts sections
shared_scripts {
    -- ... existing files
}

client_scripts {
    'client/_payroll.lua',
}

server_scripts {
    'server/[SQL]/_jobs.lua',
    'server/_payroll.lua',
}
```

## How It Works

### Player Flow

1. **Player joins server**
   - Gets assigned to a job
   - `job_payroll_tracking` entry created automatically

2. **Player goes on-duty**
   - Uses `/duty` command
   - Server sets `On_Duty = TRUE` and `On_Duty_Start = NOW()`
   - Player sees confirmation

3. **Player works**
   - Stays on-duty
   - Time accumulates

4. **Every 30 minutes - Payroll Cycle**
   - System checks all on-duty employees
   - Validates 20+ minutes worked
   - Checks job account balance
   - Processes eligible payments
   - Sends notifications

5. **Player goes off-duty**
   - Uses `/duty` again
   - Server sets `On_Duty = FALSE`
   - Player no longer receives payments

### Behind the Scenes

**Payroll Processing (Every 30 Minutes)**

```
FOR EACH configured job:
  1. Get all On_Duty = TRUE employees
  2. FOR EACH employee:
     a. Calculate minutes worked: NOW() - On_Duty_Start
     b. IF minutes >= 20:
        - Mark for payment (pending)
     c. ELSE:
        - Mark as declined (insufficient time)
  3. Get job account balance
  4. Calculate total needed for all pending payments
  5. IF balance >= total:
     a. Process all pending payments
     b. Set status to "success"
  6. ELSE:
     a. Mark all as declined (insufficient funds)
  7. FOR EACH employee:
     a. Add funds to player bank IF status = "success"
     b. Log transaction
     c. Notify player
```

## Payment Examples

### Example 1: Successful Payment

**Setup**
- Police job account: $5,000
- 10 officers on-duty
- Each officer configured for: $150 payment, 20-minute minimum
- Officers worked: 25 minutes each

**Result**
- Total deducted from police job: $1,500
- Each officer receives: +$150
- Each officer sees: "You received $150.00 for your work at police"
- Job account balance: $3,500

### Example 2: Insufficient Minimum Time

**Setup**
- Officer goes on-duty at 12:00 PM
- Payroll runs at 12:15 PM
- Officer worked: 15 minutes
- Minimum required: 20 minutes

**Result**
- Payment declined
- No funds transferred
- Officer sees: "Payroll declined: Insufficient work time (15/20 minutes)"
- Transaction logged with amount = $0

### Example 3: Insufficient Job Account Balance

**Setup**
- Police job account: $800 remaining
- 10 officers on-duty, all eligible
- Payment per officer: $150 each
- Total needed: $1,500

**Result**
- ALL payments declined (all-or-nothing)
- No funds transferred
- All officers see: "Payroll declined: Job account insufficient funds"
- All transactions logged with amount = $0

## Customization

### Add New Job

1. Add to `conf.jobpayroll` in `_config/config.lua`:

```lua
conf.jobpayroll = {
    -- ... existing jobs
    ['custom_job'] = {
        enabled = true,
        payment_amount = 95.00,
        minimum_duty_minutes = 20
    },
}
```

2. Job will automatically process in next payroll cycle

### Adjust Payment Amount

Edit `conf.jobpayroll`:

```lua
['police'] = {
    enabled = true,
    payment_amount = 175.00,  -- Changed from 150.00
    minimum_duty_minutes = 20
},
```

### Change Minimum Work Time

```lua
['police'] = {
    enabled = true,
    payment_amount = 150.00,
    minimum_duty_minutes = 15  -- Changed from 20
},
```

### Disable Payroll for a Job

```lua
['police'] = {
    enabled = false,  -- Will not process payments
    payment_amount = 150.00,
    minimum_duty_minutes = 20
},
```

### Change Payment Frequency

Default is every 30 minutes. To change:

**Edit `server/_payroll.lua`:**

```lua
Citizen.CreateThread(function()
    while true do
        Wait(1200000) -- Change 1800000 (30 min) to desired milliseconds
        ig.payroll.ProcessPayroll()
    end
end)
```

| Time | Milliseconds |
|---|---|
| 15 minutes | 900000 |
| 20 minutes | 1200000 |
| 30 minutes | 1800000 |
| 60 minutes | 3600000 |

## Advanced Customization

### Grade-Based Payments (Future Feature)

Currently all employees in a job receive the same payment. To implement grade-based payments:

1. Modify `conf.jobpayroll`:

```lua
['police'] = {
    enabled = true,
    payments = {
        [1] = 100.00,  -- Recruit
        [2] = 125.00,  -- Officer
        [3] = 150.00,  -- Sergeant
        [4] = 175.00,  -- Captain
    },
    minimum_duty_minutes = 20
},
```

2. Update `ProcessJobPayroll()` in `server/_payroll.lua`:

```lua
local playerGrade = GetPlayerJobGrade(characterId)
local paymentAmount = config.payments[playerGrade] or config.payments[1]
```

### Tax Deduction

Add to payment logic:

```lua
local tax = paymentAmount * (conf.default.tax / 100)
local netPayment = paymentAmount - tax
```

### Performance Bonus

Track actions and add multiplier:

```lua
local performanceMultiplier = GetPlayerPerformanceMultiplier(characterId)
local bonusPayment = paymentAmount * performanceMultiplier
```

## Troubleshooting

### Problem: Payroll Not Running

**Check:**
```lua
-- In server console
print(conf.enablejobpayroll)  -- Should be: true
print(conf.jobpayroll['police']) -- Should print config table
```

**Solution:** Ensure `conf.enablejobpayroll = true` in config

### Problem: Players Not Receiving Payments

**Check:**
```sql
-- Are there on-duty employees?
SELECT * FROM job_payroll_tracking WHERE On_Duty = TRUE;

-- Is job account funded?
SELECT * FROM banking_job_accounts WHERE Job = 'police';

-- Did transaction get logged?
SELECT * FROM banking_transactions WHERE Type = 'Payroll' ORDER BY Date DESC;
```

**Solution:** Verify employees are on-duty and job has funds

### Problem: Payments Declining for No Reason

**Check:**
1. Is minimum work time being met?
   ```sql
   SELECT TIMESTAMPDIFF(MINUTE, On_Duty_Start, NOW()) 
   FROM job_payroll_tracking WHERE Character_ID = ?;
   ```

2. Does job account have funds?
   ```sql
   SELECT Bank FROM banking_job_accounts WHERE Job = 'police';
   ```

### Problem: Script Errors

**Check console for:**
- `[Payroll]` messages (should see processing logs)
- Any errors in red

**Common errors:**
- Missing `ig.math.Decimals()` → Ensure `shared/[Tools]/_math.lua` is loaded
- Missing `ig.data.GetPlayer()` → Check ESX integration
- Missing `ig.sql.*` → Ensure SQL functions loaded first

## Performance Metrics

### Example Scenario: 500 Officers on Duty

**Processing Timeline:**
- Get on-duty employees: 5ms
- Validate eligibility: 50ms
- Check balance: 5ms
- Create batch queries: 25ms
- Execute batch: 50ms
- Send notifications (25 per batch, 20 batches, 100ms breaks): 2000ms
- **Total: ~2.1 seconds**

**Memory Usage:**
- Per employee: ~200 bytes
- 500 employees: ~100KB
- Negligible impact

**Database Impact:**
- Queries per cycle: ~7 (1 select, 1 balance check, 2+ batch updates)
- vs 500 individual queries without batching
- **95% reduction in database load**

## Monitoring

### SQL Queries to Monitor Payroll

**Check recent payments:**
```sql
SELECT CHARACTER_ID, Type, Description, Amount, Date 
FROM banking_transactions 
WHERE Type = 'Payroll' 
ORDER BY Date DESC 
LIMIT 50;
```

**Check current on-duty status:**
```sql
SELECT c.First_Name, c.Last_Name, p.Job, p.On_Duty, p.On_Duty_Start,
       TIMESTAMPDIFF(MINUTE, p.On_Duty_Start, NOW()) as Minutes_Worked
FROM job_payroll_tracking p
JOIN characters c ON p.Character_ID = c.Character_ID
WHERE p.On_Duty = TRUE
ORDER BY p.Job;
```

**Check job account balances:**
```sql
SELECT Job, CONCAT('$', FORMAT(Bank, 2)) as Balance 
FROM banking_job_accounts 
ORDER BY Job;
```

**Check payment statistics:**
```sql
SELECT 
    DATE(Date) as Payment_Date,
    COUNT(*) as Total_Payments,
    SUM(Amount) as Total_Paid,
    AVG(Amount) as Average_Payment
FROM banking_transactions 
WHERE Type = 'Payroll' AND Amount > 0
GROUP BY DATE(Date)
ORDER BY Date DESC;
```

## Support

For issues or questions:
1. Check console logs (filter for "[Payroll]")
2. Review database state (queries above)
3. Verify configuration is correct
4. Check player is actually on-duty
5. Ensure job account has sufficient balance
