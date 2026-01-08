# ig.job.GetOnlineMembers

## Description

Get all job members

## Signature

```lua
function ig.job.GetOnlineMembers(jobName)
```

## Parameters

- **`grade`**: number|nil Grade (if checking specific grade)
- **`jobName`**: string Job name
- **`jobName`**: string Job name

## Example

```lua
-- Example usage of ig.job.GetOnlineMembers
local result = ig.job.GetOnlineMembers()
```

## Related Functions

- [ig.job.CalculatePayroll](ig_job_CalculatePayroll.md)
- [ig.job.Exists](ig_job_Exists.md)
- [ig.job.GetAll](ig_job_GetAll.md)
- [ig.job.GetAllStats](ig_job_GetAllStats.md)
- [ig.job.GetBosses](ig_job_GetBosses.md)

## Source

Defined in: `server/[Objects]/_jobs.lua`
