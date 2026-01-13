# ig.vehicle.GetAllPersistentVehicles

## Description

Returns the complete in-memory cache of all persistent vehicles. This is the entire vehicle cache table keyed by license plate.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.GetAllPersistentVehicles()
```

## Parameters

None

## Returns

- **`table`** - Complete cache table with all vehicles (plate -> vehicle data)

## Example

```lua
-- Get all persistent vehicles
local allVehicles = ig.vehicle.GetAllPersistentVehicles()

-- Iterate through all vehicles
for plate, vehicleData in pairs(allVehicles) do
    print("Vehicle: " .. plate .. " - Model: " .. vehicleData.model)
end

-- Count total vehicles
local count = 0
for _ in pairs(allVehicles) do
    count = count + 1
end
print("Total persistent vehicles: " .. count)
```

## Related Functions

- [ig.vehicle.GetPersistentVehicle](ig_vehicle_GetPersistentVehicle.md) - Get single vehicle
- [ig.vehicle.LoadPersistentVehicles](ig_vehicle_LoadPersistentVehicles.md) - Load cache
- [ig.vehicle.SavePersistentVehicles](ig_vehicle_SavePersistentVehicles.md) - Save cache

## Use Cases

- **Statistics**: Count/analyze vehicle data
- **Bulk Operations**: Perform actions on all vehicles
- **Debugging**: Inspect entire cache
- **Admin Commands**: List all persistent vehicles

## Structure

Returns the cache table directly:

```lua
{
    ["ABC123"] = { plate = "ABC123", model = 123456, ... },
    ["XYZ789"] = { plate = "XYZ789", model = 654321, ... },
    ...
}
```

## Notes

- Returns direct reference to cache (not a copy)
- Direct table lookup with no filtering
- Use for bulk operations or statistics
- For single vehicle, use `GetPersistentVehicle(plate)`

