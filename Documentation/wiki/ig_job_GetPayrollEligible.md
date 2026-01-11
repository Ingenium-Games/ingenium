# ig.job.GetPayrollEligible

## Description

Retrieves and returns payrolleligible data

## Signature

```lua
function ig.job.GetPayrollEligible(jobName)
```

## Parameters

- **`jobName`**: any

## Example

```lua
-- Get payrolleligible data
local result = ig.job.GetPayrollEligible(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
