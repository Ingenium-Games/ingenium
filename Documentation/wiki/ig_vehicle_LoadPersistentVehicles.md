# ig.vehicle.LoadPersistentVehicles

## Description

Loads persistent vehicles from the JSON file (`data/persistent_vehicles.json`) into memory. Parses the JSON file and populates the in-memory cache (`ig.vehicleCache`). Called during initialization and can be called manually to reload data.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.LoadPersistentVehicles()
```

## Parameters

None

## Returns

None

## Example

```lua
-- Load vehicles on startup
ig.vehicle.LoadPersistentVehicles()

-- Later, manually reload from file
ig.vehicle.LoadPersistentVehicles()
```

## Related Functions

- [ig.vehicle.SavePersistentVehicles](ig_vehicle_SavePersistentVehicles.md) - Save to file
- [ig.vehicle.InitializePersistence](ig_vehicle_InitializePersistence.md) - System init
- [ig.vehicle.GetAllPersistentVehicles](ig_vehicle_GetAllPersistentVehicles.md) - Access cache

## Purpose

- **Data Recovery**: Restores vehicle data from disk to memory
- **Cache Population**: Fills `ig.vehicleCache` with saved vehicles
- **System Init**: Part of initialization sequence

## Behavior

- Returns silently if file doesn't exist (first run)
- Handles invalid JSON gracefully
- Logs errors if parsing fails
- Populates `ig.vehicleCache` table
- Logs loaded vehicle count

## File Format

Expects JSON file at `data/persistent_vehicles.json`:

```json
{
    "version": 1,
    "lastSaved": "2024-01-15T10:30:00Z",
    "vehicles": {
        "ABC123": {
            "plate": "ABC123",
            "model": 123456,
            "condition": { ... },
            "modifications": { ... },
            ...
        }
    }
}
```

## Notes

- Idempotent: safe to call multiple times
- Gracefully handles missing files
- Validates JSON before parsing
- Logs results based on config settings
- Part of system startup process

