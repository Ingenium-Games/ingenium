# ig.pick.CreateZone

## Description

Creates a new zone instance

## Signature

```lua
function ig.pick.CreateZone(center, radius, count, models, data)
```

## Parameters

- **`center`**: any
- **`radius`**: any
- **`count`**: string
- **`models`**: any
- **`data`**: number

## Example

```lua
-- Create new zone
local created = ig.pick.CreateZone(value, value, "count", value, 100)
if created then
    print("Created successfully")
end
```

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
