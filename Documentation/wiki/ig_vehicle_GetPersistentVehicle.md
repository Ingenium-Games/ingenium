# ig.vehicle.GetPersistentVehicle

## Description

Retrieves vehicle data from the persistence cache by license plate. Returns the complete vehicle entry including condition, modifications, location, and metadata.

**Scope:** Server
**Namespace:** ig.vehicle
**Category:** Vehicle Persistence

## Signature

```lua
function ig.vehicle.GetPersistentVehicle(plate)
```

## Parameters

- **`plate`**: `string` - Vehicle license plate

## Returns

- **`table`** - Vehicle data or `nil` if not found

## Example

```lua
-- Retrieve vehicle data by plate
local vehicleData = ig.vehicle.GetPersistentVehicle("ABC123")
if vehicleData then
    print("Vehicle model: " .. vehicleData.model)
    print("Last seen at: " .. vehicleData.coords.x)
end
```

## Related Functions

- [ig.vehicle.GetAllPersistentVehicles](ig_vehicle_GetAllPersistentVehicles.md) - Get all vehicles
- [ig.vehicle.RegisterPersistent](ig_vehicle_RegisterPersistent.md) - Register vehicle
- [ig.vehicle.RestorePersistentVehicle](ig_vehicle_RestorePersistentVehicle.md) - Spawn vehicle

## Data Structure

Returned table contains:

```lua
{
    plate = "ABC123",
    model = 123456,
    type = "world",  -- 'owned', 'npc', or 'world'
    npcOwner = nil,
    owner = player_character_id,
    registeredBy = player_server_id,
    registeredAt = "2024-01-15T10:30:00Z",
    lastInteraction = "2024-01-15T10:30:00Z",
    interactionCount = 1,
    coords = {x = 100.0, y = 200.0, z = 50.0, h = 45.5},
    fuel = 85.5,
    condition = { ... },  -- Damage/condition data
    modifications = { ... },  -- Tuning data
    statebag = {}  -- Additional state variables
}
```

## Purpose

- **Query Vehicle Data**: Access saved vehicle information
- **Respawn Logic**: Get data to restore vehicle
- **Admin Tools**: Check vehicle history/metadata

## Notes

- Returns `nil` if vehicle not found
- Direct cache lookup (O(1) operation)
- Contains all vehicle state information
- Used before respawning vehicles

