# ig.job.GetStats

## Description

Get total member count (online + offline)

## Signature

```lua
function ig.job.GetStats(jobName)
```

## Parameters

- **`jobName`**: any

## Example

```lua
-- Get stats data
local result = ig.job.GetStats(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
