# ig.vehicle.RestorePersistentVehicle

## Description

Spawns a persistent vehicle from saved data. Requests the vehicle model, creates the entity at the saved location, applies condition/modifications using ig.func utilities, sets fuel, and cleans up the model. Returns the new vehicle entity handle.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.RestorePersistentVehicle(vehicleData)
```

## Parameters

- **`vehicleData`**: `table` - Vehicle data from cache (from GetPersistentVehicle)

## Returns

- **`number`** - Vehicle entity handle, or `nil` if spawn failed

## Example

```lua
-- Get and restore a persistent vehicle
local vehicleData = ig.vehicle.GetPersistentVehicle("ABC123")
if vehicleData then
    local vehicle = ig.vehicle.RestorePersistentVehicle(vehicleData)
    if vehicle then
        print("Vehicle restored: " .. vehicleData.plate)
    end
end
```

## Related Functions

- [ig.vehicle.GetPersistentVehicle](ig_vehicle_GetPersistentVehicle.md) - Get vehicle data
- [ig.func.SetVehicleCondition](ig_func_SetVehicleCondition.md) - Apply damage state
- [ig.func.SetVehicleModifications](ig_func_SetVehicleModifications.md) - Apply mods
- [ig.func.SetVehicleStatebag](ig_func_SetVehicleStatebag.md) - Apply all state

## What It Does

1. Validates vehicle data exists
2. Requests model with 5 second timeout
3. Creates vehicle at saved location and heading
4. Sets license plate
5. Applies condition via `ig.func.SetVehicleCondition()`
6. Applies modifications via `ig.func.SetVehicleModifications()`
7. Sets fuel level
8. Cleans up model reference
9. Logs result if logging enabled
10. Returns entity handle or nil

## Restoration Details

- Restores to exact saved location (x, y, z)
- Restores exact heading/rotation
- Restores fuel level
- Restores all damage and condition
- Restores all modifications and customizations
- Restores statebag if available

## Notes

- Returns `nil` if model fails to load (5 sec timeout)
- Async model request doesn't block event
- Uses ig.func utilities for safe state application
- Respects logging config settings
- Safe to call with invalid data (returns nil)

