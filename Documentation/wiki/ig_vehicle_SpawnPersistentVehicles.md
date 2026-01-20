# ig.vehicle.SpawnPersistentVehicles

## Description

Spawns all persistent vehicles that should be active in the game world based on their saved state.

## Signature

```lua
function ig.vehicle.SpawnPersistentVehicles()
```

## Parameters

None

## Returns

None

## Behavior

- Loads persistent vehicle data from storage
- Spawns vehicles at their saved locations
- Restores vehicle state (mods, damage, etc.)
- Registers vehicles with the vehicle system

## Example

```lua
-- This function is typically called automatically on resource start
-- Manual invocation:
ig.vehicle.SpawnPersistentVehicles()
```

## Source

Defined in: `server/_vehicle_persistence.lua`
