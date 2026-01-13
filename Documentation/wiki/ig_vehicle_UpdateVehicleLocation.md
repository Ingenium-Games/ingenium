# ig.vehicle.UpdateVehicleLocation

## Description

Updates a vehicle's position, heading, and fuel level in the persistence cache and database. Called when the client sends the vehicle exit data.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.UpdateVehicleLocation(plate, coords, heading, fuel)
```

## Parameters

- **`plate`**: `string` - Vehicle license plate
- **`coords`**: `table` - Vehicle coordinates {x, y, z}
- **`heading`**: `number` - Vehicle heading/rotation
- **`fuel`**: `number` - Current fuel level

## Returns

None

## Example

```lua
-- Update vehicle location and fuel
local coords = {x = 100.0, y = 200.0, z = 50.0}
ig.vehicle.UpdateVehicleLocation("ABC123", coords, 45.5, 75.3)
```

## Related Functions

- [ig.vehicle.RegisterPersistent](ig_vehicle_RegisterPersistent.md) - Initial registration
- [ig.vehicle.UpdateVehicleState](ig_vehicle_UpdateVehicleState.md) - Update condition/mods
- [ig.vehicle.GetPersistentVehicle](ig_vehicle_GetPersistentVehicle.md) - Retrieve vehicle data

## Purpose

- **Location Tracking**: Records vehicle position on exit
- **Fuel Preservation**: Maintains fuel level across restarts
- **Respawn Data**: Enables vehicle to respawn at last location

## Behavior

- Updates cache entry position and fuel
- Performs async database updates for both position and stats
- Updates `lastInteraction` timestamp
- Returns silently if vehicle not registered

## Notes

- Called when player exits vehicle (from client)
- Async database updates don't block execution
- Updates `lastInteraction` for vehicle tracking
- Part of vehicle exit state capture

