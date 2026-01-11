# ig.func.GetPickupsInArea

## Description

Returns Pickups within the designated radius.

## Signature

```lua
function ig.func.GetPickupsInArea(coords, radius, minimal)
```

## Parameters

- **`coords`**: any
- **`radius`**: any
- **`minimal`**: any

## Example

```lua
-- Get pickupsinarea data
local result = ig.func.GetPickupsInArea(value, value, value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_functions.lua`
