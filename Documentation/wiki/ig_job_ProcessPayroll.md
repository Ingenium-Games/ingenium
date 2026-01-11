# ig.job.ProcessPayroll

## Description

Processes payroll for all eligible employees in jobs. Calculates and distributes salaries based on job grades and online time. Typically run on a scheduled basis.

## Signature

```lua
function ig.job.ProcessPayroll(jobName, useJobFunds)
```

## Parameters

- **`jobName`**: string
- **`useJobFunds`**: any

## Example

```lua
-- Process payroll for all jobs
ig.job.ProcessPayroll()

-- This will:
-- 1. Find all eligible employees
-- 2. Calculate salaries based on grade
-- 3. Deposit money into accounts
-- 4. Log transactions
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
