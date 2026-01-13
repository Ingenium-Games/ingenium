# ig.vehicle.HookVehicleEvents

## Description

Sets up event hooks into the existing vehicle enter/exit event system. Hooks into `Server:Vehicle:OnPlayerEntered` to register and track persistent vehicles. Called during system initialization.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.HookVehicleEvents()
```

## Parameters

None

## Returns

None

## Example

```lua
-- Hook into vehicle events (called automatically)
ig.vehicle.HookVehicleEvents()
```

## Related Functions

- [ig.event.Server:Vehicle:OnPlayerEntered](ig_event_ServerOnPlayerEnteredVehicle.md) - Vehicle enter event
- [ig.vehicle.RegisterPersistent](ig_vehicle_RegisterPersistent.md) - Register vehicle
- [ig.vehicle.InitializePersistence](ig_vehicle_InitializePersistence.md) - System init

## Purpose

- **Event Integration**: Connects persistence to vehicle system
- **Registration**: Registers vehicles when players enter them
- **Interaction Tracking**: Updates vehicle interaction count

## What It Does

Listens to `Server:Vehicle:OnPlayerEntered` and:
1. Checks if persistence is enabled
2. Validates vehicle exists
3. Extracts plate number
4. Gets player info for ownership tracking
5. Registers vehicle if not already cached (type: 'world')
6. Updates interaction count if already registered

## Key Features

- **Automatic Registration**: Vehicles registered on player entry
- **Reuse Detection**: Skips duplicate registration
- **Interaction Tracking**: Counts vehicle interactions
- **Type Classification**: Defaults to 'world' type for generic vehicles

## Notes

- Called automatically during `InitializePersistence()`
- Uses existing event system (no polling)
- Minimal performance impact
- Integrates seamlessly with framework events

