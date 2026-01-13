# ig.vehicle.SavePersistentVehicles

## Description

Saves the in-memory vehicle cache (`ig.vehicleCache`) to a JSON file (`data/persistent_vehicles.json`). Called periodically (every 5 minutes) and on resource shutdown. Creates the data directory if needed.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.SavePersistentVehicles()
    local dataToSave = {
        version = 1,
        lastSaved = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        vehicles = ig.vehicleCache
    }
    -- ... saves to file
end
```

## Parameters

None

## Returns

- **`boolean`** - `true` if save was successful, `false` otherwise

## Example

```lua
-- Save vehicles manually
local success = ig.vehicle.SavePersistentVehicles()
if success then
    print("Vehicles saved successfully")
else
    print("Failed to save vehicles")
end
```

## Related Functions

- [ig.vehicle.LoadPersistentVehicles](ig_vehicle_LoadPersistentVehicles.md) - Load from file
- [ig.vehicle.StartPeriodicSave](ig_vehicle_StartPeriodicSave.md) - Periodic saving
- [ig.vehicle.GetAllPersistentVehicles](ig_vehicle_GetAllPersistentVehicles.md) - Access cache

## Purpose

- **Data Persistence**: Saves vehicle data to disk
- **Backup**: Creates persistent copy of vehicle state
- **Recovery**: Enables vehicle restoration on server restart

## Behavior

- Includes version and timestamp in file
- Creates `data/` directory if missing
- Logs errors if write fails
- Respects `conf.persistence.logging.enabled`
- Called automatically every 5 minutes
- Called on resource stop

## File Format

Creates JSON file with structure:

```json
{
    "version": 1,
    "lastSaved": "2024-01-15T10:30:00Z",
    "vehicles": {
        "ABC123": { ... },
        "XYZ789": { ... }
    }
}
```

## Notes

- Idempotent: safe to call multiple times
- Creates data directory automatically
- Non-blocking with lua file I/O
- Returns success/failure status
- Can be called manually anytime

