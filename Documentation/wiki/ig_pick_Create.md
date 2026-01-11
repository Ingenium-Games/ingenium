# ig.pick.Create

## Description

Creates a new  instance

## Signature

```lua
function ig.pick.Create(coords, model, event, data)
```

## Parameters

- **`coords`**: any
- **`model`**: any
- **`event`**: any
- **`data`**: table

## Example

```lua
-- Create new 
local created = ig.pick.Create(value, value, value, {})
if created then
    print("Created successfully")
end
```

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
