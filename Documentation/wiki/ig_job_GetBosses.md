# ig.job.GetBosses

## Description

Retrieves and returns bosses data

## Signature

```lua
function ig.job.GetBosses(jobName)
```

## Parameters

- **`jobName`**: any

## Example

```lua
-- Get bosses data
local result = ig.job.GetBosses(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
