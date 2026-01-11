# ig.pick.CreateLoot

## Description

Creates a new loot instance

## Signature

```lua
function ig.pick.CreateLoot(coords, items, model, respawnTime)
```

## Parameters

- **`coords`**: any
- **`items`**: any
- **`model`**: any
- **`respawnTime`**: any

## Example

```lua
-- Create new loot
local created = ig.pick.CreateLoot(value, value, value, value)
if created then
    print("Created successfully")
end
```

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
