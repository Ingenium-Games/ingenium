# ig.job.GetMembers

## Description

Retrieves and returns members data

## Signature

```lua
function ig.job.GetMembers(jobName)
```

## Parameters

- **`jobName`**: any

## Example

```lua
-- Get members data
local result = ig.job.GetMembers(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
