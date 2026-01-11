# ig.job.GetByBoss

## Description

Retrieves and returns byboss data

## Signature

```lua
function ig.job.GetByBoss(characterId)
```

## Parameters

- **`characterId`**: any

## Example

```lua
-- Get byboss data
local result = ig.job.GetByBoss(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_jobs.lua`
