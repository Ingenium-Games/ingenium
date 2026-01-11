# ig.vehicle.GetCurrentVehicle

## Description

Retrieves and returns currentvehicle data

## Signature

```lua
function ig.vehicle.GetCurrentVehicle()
```

## Parameters

*No parameters*

## Example

```lua
-- Get currentvehicle data
local result = ig.vehicle.GetCurrentVehicle()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_vehicle.lua`
