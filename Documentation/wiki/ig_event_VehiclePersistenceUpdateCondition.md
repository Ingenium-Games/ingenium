# ig.event.Server:VehiclePersistence:UpdateCondition

## Description

Network event triggered from client to server to update a vehicle's final condition, modifications, location, heading, and fuel level when a player exits the vehicle. Part of the vehicle persistence system for maintaining accurate vehicle state.

**Scope:** Server-side network event
**Resource:** Ingenium
**Direction:** Client → Server
**Namespace:** Server Vehicle Persistence Events

## Signature

```lua
RegisterNetEvent("Server:VehiclePersistence:UpdateCondition", function(netId, plate, condition, modifications, coords, heading, fuel) end)
```

## Parameters

- **`netId`**: `number` - Network ID of the vehicle entity
- **`plate`**: `string` - Vehicle license plate
- **`condition`**: `table` - Final vehicle condition data (doors, windows, panels, lights)
- **`modifications`**: `table` - Final vehicle modifications state
- **`coords`**: `table` - Vehicle position {x, y, z}
- **`heading`**: `number` - Vehicle heading/rotation
- **`fuel`**: `number` - Current fuel level

## Returns

None

## Example

```lua
-- Server handles vehicle condition update on exit
RegisterNetEvent("Server:VehiclePersistence:UpdateCondition", function(netId, plate, condition, modifications, coords, heading, fuel)
    print("Updating vehicle: " .. plate)
    print("Final condition, location, and fuel stored")
end)
```

## Related Events

- [Server:VehiclePersistence:RegisterCondition](ig_event_VehiclePersistenceRegisterCondition.md) - Register on vehicle entry
- [vehicle:persistence:updated](ig_event_VehiclePersistenceUpdated.md) - Server notification to client
- [Server:Vehicle:OnPlayerLeft](ig_event_ServerOnPlayerLeftVehicle.md) - Internal vehicle exit event

## Source

Triggered from: `client/[Events]/_vehicle.lua` (Line ~44)
Registered in: `server/[Events]/_vehicle.lua`

## Security Notes

- **Server-Authoritative State**: Server reads vehicle statebag directly from the entity
- Client sends ONLY: identifiers (netId, plate) + visual state (condition, mods, coords, heading, fuel)
- Client does NOT send: statebag (server-hosted state - prevented for security)
- Server verifies netId and reads statebag via `NetworkGetEntityFromNetworkId()`

## Persistence Flow

1. Client detects player exiting vehicle
2. Client captures final vehicle state (condition, mods, location, fuel)
3. Client sends `Server:VehiclePersistence:UpdateCondition` to server
4. Server reads complete statebag from vehicle entity (authoritative)
5. Server updates cache and database with final state
6. Server sends confirmation via `vehicle:persistence:updated`

## Notes

- Fired automatically when player leaves a vehicle
- Captures final vehicle state before despawn or storage
- Location data used for respawning vehicle at last location
- Fuel level preserved across restarts
- Event-driven, minimal performance impact

