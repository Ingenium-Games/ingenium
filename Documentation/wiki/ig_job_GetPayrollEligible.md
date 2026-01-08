# ig.job.GetPayrollEligible

## Description

Get job by boss character ID

## Signature

```lua
function ig.job.GetPayrollEligible(jobName)
```

## Parameters

- **`characterId`**: string Character ID
- **`characterId`**: string Character ID
- **`jobName`**: string|nil Specific job or nil for all

## Example

```lua
-- Example usage of ig.job.GetPayrollEligible
local result = ig.job.GetPayrollEligible()
```

## Related Functions

- [ig.job.CalculatePayroll](ig_job_CalculatePayroll.md)
- [ig.job.Exists](ig_job_Exists.md)
- [ig.job.GetAll](ig_job_GetAll.md)
- [ig.job.GetAllStats](ig_job_GetAllStats.md)
- [ig.job.GetBosses](ig_job_GetBosses.md)

## Source

Defined in: `server/[Objects]/_jobs.lua`
