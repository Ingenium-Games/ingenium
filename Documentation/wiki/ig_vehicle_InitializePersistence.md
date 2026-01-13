# ig.vehicle.InitializePersistence

## Description

Initializes the vehicle persistence system. Loads previously saved vehicles from the JSON file, starts the periodic save thread, and hooks into existing vehicle events. Should be called once during resource startup.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.InitializePersistence()
```

## Parameters

None

## Returns

None

## Example

```lua
-- Initialize persistence system on resource start
ig.vehicle.InitializePersistence()
```

## Related Functions

- [ig.vehicle.LoadPersistentVehicles](ig_vehicle_LoadPersistentVehicles.md) - Load from file
- [ig.vehicle.SavePersistentVehicles](ig_vehicle_SavePersistentVehicles.md) - Save to file
- [ig.vehicle.RegisterPersistent](ig_vehicle_RegisterPersistent.md) - Register vehicle
- [ig.vehicle.HookVehicleEvents](ig_vehicle_HookVehicleEvents.md) - Setup event hooks

## Purpose

- **System Bootstrap**: Initializes all persistence subsystems
- **Data Recovery**: Loads previously saved vehicles from disk
- **Event Integration**: Hooks into existing vehicle events
- **Background Tasks**: Starts periodic save thread

## What It Does

1. Checks if persistence is enabled in config
2. Logs system status
3. Calls `LoadPersistentVehicles()` to restore from JSON
4. Starts periodic save thread (5 minute interval)
5. Sets up event hooks for vehicle enter/exit
6. Logs loaded vehicle count

## Notes

- Called automatically on resource start via CreateThread
- Respects `conf.persistence.enablePersistence` setting
- Logs all initialization steps for debugging
- Safe to call multiple times (idempotent)

## Configuration

Requires config settings:

```lua
conf.persistence = {
    enablePersistence = true,  -- Enable/disable entire system
    logging = {
        enabled = true          -- Enable debug logging
    }
}
```

