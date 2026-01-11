# ig.func.GetVehiclesInArea

## Description

Returns Vehicles within the designated radius.

## Signature

```lua
function ig.func.GetVehiclesInArea(ords, radius, minimal)
```

## Parameters

- **`ords`**: any
- **`radius`**: any
- **`minimal`**: any

## Example

```lua
-- Get vehiclesinarea data
local result = ig.func.GetVehiclesInArea(value, value, value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_functions.lua`
