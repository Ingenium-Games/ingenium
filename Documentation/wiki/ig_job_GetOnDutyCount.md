# ig.job.GetOnDutyCount

## Description

Get job count

## Signature

```lua
function ig.job.GetOnDutyCount(jobName)
```

## Parameters

- **`category`**: string Category (e.g., "public", "private", "gang")
- **`jobName`**: string Job name

## Example

```lua
-- Example usage of ig.job.GetOnDutyCount
local result = ig.job.GetOnDutyCount()
```

## Related Functions

- [ig.job.CalculatePayroll](ig_job_CalculatePayroll.md)
- [ig.job.Exists](ig_job_Exists.md)
- [ig.job.GetAll](ig_job_GetAll.md)
- [ig.job.GetAllStats](ig_job_GetAllStats.md)
- [ig.job.GetBosses](ig_job_GetBosses.md)

## Source

Defined in: `server/[Objects]/_jobs.lua`
