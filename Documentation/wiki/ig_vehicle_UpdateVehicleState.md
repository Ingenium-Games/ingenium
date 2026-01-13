# ig.vehicle.UpdateVehicleState

## Description

Updates a vehicle's condition and modifications state in the persistence cache and database. Called when the client sends condition data (on vehicle entry).

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.UpdateVehicleState(plate, condition, modifications)
```

## Parameters

- **`plate`**: `string` - Vehicle license plate
- **`condition`**: `table` - Vehicle condition data (doors, windows, panels, lights)
- **`modifications`**: `table` - Vehicle modifications data

## Returns

None

## Example

```lua
-- Update vehicle state when client sends condition data
ig.vehicle.UpdateVehicleState("ABC123", conditionData, modificationsData)
```

## Related Functions

- [ig.vehicle.RegisterPersistent](ig_vehicle_RegisterPersistent.md) - Initial registration
- [ig.vehicle.UpdateVehicleLocation](ig_vehicle_UpdateVehicleLocation.md) - Update position/fuel
- [ig.vehicle.GetPersistentVehicle](ig_vehicle_GetPersistentVehicle.md) - Retrieve vehicle data

## Purpose

- **State Tracking**: Records vehicle condition and modifications
- **Persistence**: Saves condition state to cache and database
- **Update Timestamp**: Records last interaction time

## Behavior

- Updates cache entry condition and modifications
- Performs async database update
- Updates `lastInteraction` timestamp
- Returns silently if vehicle not registered

## Notes

- Called by server event handler when client sends condition data
- Async database update doesn't block execution
- Updates `lastInteraction` for vehicle tracking
- Part of the persistent state system

