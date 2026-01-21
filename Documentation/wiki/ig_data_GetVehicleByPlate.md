# ig.data.GetVehicleByPlate

## Description

Retrieves a vehicle entity by its license plate.

## Signature

```lua
function ig.data.GetVehicleByPlate(plate)
```

## Parameters

- **`plate`**: string - The license plate of the vehicle

## Returns

- **`table|false`** - The vehicle entity table if found, `false` otherwise

## Example

```lua
-- Get a vehicle by plate
local vehicle = ig.data.GetVehicleByPlate("ABC123")
if vehicle then
    print("Vehicle network ID:", vehicle.Network)
end
```

## Source

Defined in: `server/_data.lua` (delegates to `ig.vehicle.GetVehicleByPlate` in `server/[Objects]/_vehicles.lua`)
