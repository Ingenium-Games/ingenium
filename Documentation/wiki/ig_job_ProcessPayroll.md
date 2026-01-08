# ig.job.ProcessPayroll

## Description

Calculate total payroll for job

## Signature

```lua
function ig.job.ProcessPayroll(jobName, useJobFunds)
```

## Parameters

- **`jobName`**: string Job name
- **`jobName`**: string Job name
- **`useJobFunds`**: boolean Use job bank account (true) or spawn money (false)

## Example

```lua
-- Example usage of ig.job.ProcessPayroll
local result = ig.job.ProcessPayroll(jobName, useJobFunds)
```

## Related Functions

- [ig.job.CalculatePayroll](ig_job_CalculatePayroll.md)
- [ig.job.Exists](ig_job_Exists.md)
- [ig.job.GetAll](ig_job_GetAll.md)
- [ig.job.GetAllStats](ig_job_GetAllStats.md)
- [ig.job.GetBosses](ig_job_GetBosses.md)

## Source

Defined in: `server/[Objects]/_jobs.lua`
