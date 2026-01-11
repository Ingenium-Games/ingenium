# ig.vehicle.GetVehicleByPlate

## Description

Retrieves and returns vehiclebyplate data

## Signature

```lua
function ig.vehicle.GetVehicleByPlate(plate)
```

## Parameters

- **`plate`**: any

## Example

```lua
-- Get vehiclebyplate data
local result = ig.vehicle.GetVehicleByPlate(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_vehicles.lua`
