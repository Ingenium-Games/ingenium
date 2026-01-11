# ig.job.GetOnlineMembers

## Description

Retrieves and returns onlinemembers data

## Signature

```lua
function ig.job.GetOnlineMembers(jobName)
```

## Parameters

- **`jobName`**: any

## Example

```lua
-- Get onlinemembers data
local result = ig.job.GetOnlineMembers(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
