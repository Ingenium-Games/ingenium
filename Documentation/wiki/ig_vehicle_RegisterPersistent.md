# ig.vehicle.RegisterPersistent

## Description

Registers a vehicle as persistent when a player enters it. Captures vehicle model, position, fuel, and initial state. Updates interaction count if vehicle already exists. Triggers client to capture full condition/modifications data.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.RegisterPersistent(vehicleEntity, playerId, plate, vehicleType, npcOwner)
```

## Parameters

- **`vehicleEntity`**: `number` - Vehicle entity handle
- **`playerId`**: `number` - Player server ID
- **`plate`**: `string` - Vehicle license plate
- **`vehicleType`**: `string` - Type: `'owned'`, `'npc'`, or `'world'`
- **`npcOwner`**: `string` - NPC identifier if applicable (optional)

## Returns

None

## Example

```lua
-- Register a vehicle as persistent
ig.vehicle.RegisterPersistent(vehicle, source, GetVehicleNumberPlateText(vehicle), "world", nil)
```

## Related Functions

- [ig.vehicle.UpdateVehicleState](ig_vehicle_UpdateVehicleState.md) - Update condition/mods
- [ig.vehicle.UpdateVehicleLocation](ig_vehicle_UpdateVehicleLocation.md) - Update position/fuel
- [ig.vehicle.GetPersistentVehicle](ig_vehicle_GetPersistentVehicle.md) - Retrieve vehicle data
- [ig.vehicle.RestorePersistentVehicle](ig_vehicle_RestorePersistentVehicle.md) - Spawn vehicle

## Purpose

- **Initial Registration**: Registers vehicle on first player entry
- **State Capture**: Begins vehicle state tracking
- **Interaction Tracking**: Updates entry count and timestamp

## What It Does

1. Validates plate is not empty
2. Checks if vehicle already registered
3. Increments interaction count if existing
4. Creates new cache entry if new vehicle
5. Captures: model, position, heading, fuel, owner info
6. Updates database with registration
7. Requests client to capture full condition/modifications

## Cache Entry Structure

```lua
{
    plate = "ABC123",
    model = 123456,
    type = "world",
    npcOwner = nil,
    owner = player_character_id,
    registeredBy = player_server_id,
    registeredAt = "2024-01-15T10:30:00Z",
    lastInteraction = "2024-01-15T10:30:00Z",
    interactionCount = 1,
    coords = {x = 100.0, y = 200.0, z = 50.0, h = 45.5},
    fuel = 85.5,
    condition = nil,  -- Filled by client
    modifications = nil,  -- Filled by client
    statebag = {}  -- Server reads from entity
}
```

## Notes

- Skips duplicate registrations (only updates interaction count)
- Async database update doesn't block execution
- Uses `TriggerClientEvent` to request condition capture
- Respects logging config settings
- Part of vehicle entry flow

