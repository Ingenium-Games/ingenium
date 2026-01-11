# ig.job.GetOnDutyCount

## Description

Retrieves and returns ondutycount data

## Signature

```lua
function ig.job.GetOnDutyCount(jobName)
```

## Parameters

- **`jobName`**: any

## Example

```lua
-- Get ondutycount data
local result = ig.job.GetOnDutyCount(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
