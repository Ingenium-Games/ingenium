# ig.job.ValidateData

## Description

Resync job data to client

## Signature

```lua
function ig.job.ValidateData(jobData)
```

## Parameters

- **`source`**: number Player source
- **`jobName`**: string|nil Specific job or nil for all
- **`jobData`**: table Job data to validate

## Example

```lua
-- Example usage of ig.job.ValidateData
local result = ig.job.ValidateData(jobData)
```

## Important Notes

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.job.CalculatePayroll](ig_job_CalculatePayroll.md)
- [ig.job.Exists](ig_job_Exists.md)
- [ig.job.GetAll](ig_job_GetAll.md)
- [ig.job.GetAllStats](ig_job_GetAllStats.md)
- [ig.job.GetBosses](ig_job_GetBosses.md)

## Source

Defined in: `server/[Objects]/_jobs.lua`
