# ig.vehicle.DoesVehicleExistByPlate

## Description

Checks if a vehicle with a specific license plate exists in the game world.

## Signature

```lua
function ig.vehicle.DoesVehicleExistByPlate(plate)
```

## Parameters

- **`plate`**: string - The license plate to search for

## Returns

- **`boolean`** - `true` if the vehicle exists, `false` otherwise

## Example

```lua
-- Check if vehicle exists by plate
if ig.vehicle.DoesVehicleExistByPlate("ABC123") then
    print("Vehicle with plate ABC123 exists")
end
```

## Source

Defined in: `server/_vehicle_persistence.lua`
