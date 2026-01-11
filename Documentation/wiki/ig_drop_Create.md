# ig.drop.Create

## Description

Creates a new  instance

## Signature

```lua
function ig.drop.Create(coords, items, model, targetPlayer, isDeadDrop)
```

## Parameters

- **`coords`**: any
- **`items`**: table
- **`model`**: any
- **`targetPlayer`**: any
- **`isDeadDrop`**: any

## Example

```lua
-- Create new 
local created = ig.drop.Create(value, {}, value, value, value)
if created then
    print("Created successfully")
end
```

## Source

Defined in: `server/[Data - Save to File]/_drops.lua`
