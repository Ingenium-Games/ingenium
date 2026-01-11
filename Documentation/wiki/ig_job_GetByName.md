# ig.job.GetByName

## Description

Retrieves and returns byname data

## Signature

```lua
function ig.job.GetByName(name)
```

## Parameters

- **`name`**: number

## Example

```lua
-- Get byname data
local result = ig.job.GetByName(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
