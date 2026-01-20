# ig.vehicle.RestoreParkedVehicles

## Description

Restores all parked vehicles from the database when the server starts, recreating them in their saved locations.

## Signature

```lua
function ig.vehicle.RestoreParkedVehicles()
```

## Parameters

None

## Returns

None

## Behavior

- Queries database for all parked vehicles (status = "parked")
- Spawns each vehicle at its saved location
- Restores vehicle modifications and state
- Adds vehicles to the server's vehicle registry

## Example

```lua
-- This function is typically called automatically on resource start
-- Manual invocation:
ig.vehicle.RestoreParkedVehicles()
```

## Source

Defined in: `server/_vehicle_persistence.lua`
