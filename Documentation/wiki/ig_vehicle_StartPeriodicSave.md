# ig.vehicle.StartPeriodicSave

## Description

Starts a background thread that periodically saves persistent vehicles to the JSON file. Runs on a 5-minute interval. Called during system initialization.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.StartPeriodicSave()
```

## Parameters

None

## Returns

None

## Example

```lua
-- Start the periodic save thread (called automatically)
ig.vehicle.StartPeriodicSave()
```

## Related Functions

- [ig.vehicle.SavePersistentVehicles](ig_vehicle_SavePersistentVehicles.md) - Save to file
- [ig.vehicle.InitializePersistence](ig_vehicle_InitializePersistence.md) - System init

## Purpose

- **Data Durability**: Ensures vehicle data is saved regularly
- **Recovery**: Minimizes data loss on server crash
- **Background Process**: Non-blocking periodic saves

## Behavior

- Runs indefinitely while persistence is enabled
- Saves every 5 minutes (300,000 ms)
- Respects `conf.persistence.enablePersistence`
- Logs saves if logging enabled
- Runs in background thread (non-blocking)

## Technical Details

```lua
-- Runs this loop in background
CreateThread(function()
    while ig.vehicle and conf.persistence.enablePersistence do
        Wait(300000)  -- 5 minutes
        ig.vehicle.SavePersistentVehicles()
    end
end)
```

## Notes

- Called automatically during `InitializePersistence()`
- Stops when resource stops or persistence disabled
- Non-blocking thread (doesn't slow server)
- Check logs to verify saves are working

