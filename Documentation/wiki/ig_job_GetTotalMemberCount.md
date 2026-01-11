# ig.job.GetTotalMemberCount

## Description

Retrieves and returns totalmembercount data

## Signature

```lua
function ig.job.GetTotalMemberCount(jobName)
```

## Parameters

- **`jobName`**: any

## Example

```lua
-- Get totalmembercount data
local result = ig.job.GetTotalMemberCount(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
