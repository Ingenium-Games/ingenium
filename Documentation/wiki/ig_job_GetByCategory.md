# ig.job.GetByCategory

## Description

Retrieves and returns bycategory data

## Signature

```lua
function ig.job.GetByCategory(category)
```

## Parameters

- **`category`**: any

## Example

```lua
-- Get bycategory data
local result = ig.job.GetByCategory(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
