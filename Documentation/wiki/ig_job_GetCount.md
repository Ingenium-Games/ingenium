# ig.job.GetCount

## Description

Retrieves and returns count data

## Signature

```lua
function ig.job.GetCount()
```

## Parameters

*No parameters*

## Example

```lua
-- Get count data
local result = ig.job.GetCount()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
