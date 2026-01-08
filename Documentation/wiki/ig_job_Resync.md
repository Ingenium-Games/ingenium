# ig.job.Resync

## Description

Search jobs

## Signature

```lua
function ig.job.Resync(source, jobName)
```

## Parameters

- **`searchTerm`**: string Search term
- **`source`**: number Player source
- **`jobName`**: string|nil Specific job or nil for all

## Example

```lua
-- Example usage of ig.job.Resync
local result = ig.job.Resync(source, jobName)
```

## Related Functions

- [ig.job.CalculatePayroll](ig_job_CalculatePayroll.md)
- [ig.job.Exists](ig_job_Exists.md)
- [ig.job.GetAll](ig_job_GetAll.md)
- [ig.job.GetAllStats](ig_job_GetAllStats.md)
- [ig.job.GetBosses](ig_job_GetBosses.md)

## Source

Defined in: `server/[Objects]/_jobs.lua`
