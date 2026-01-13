# ig.event.Server:VehiclePersistence:RegisterCondition

## Description

Network event triggered from client to server to register a vehicle's condition and modifications when a player enters a vehicle. Part of the vehicle persistence system for tracking vehicle state across server restarts.

**Scope:** Server-side network event
**Resource:** Ingenium
**Direction:** Client → Server
**Namespace:** Server Vehicle Persistence Events

## Signature

```lua
RegisterNetEvent("Server:VehiclePersistence:RegisterCondition", function(netId, plate, condition, modifications) end)
```

## Parameters

- **`netId`**: `number` - Network ID of the vehicle entity
- **`plate`**: `string` - Vehicle license plate
- **`condition`**: `table` - Vehicle condition data (doors, windows, panels, lights)
- **`modifications`**: `table` - Vehicle modifications (tuning, upgrades, customizations)

## Returns

None

## Example

```lua
-- Server handles vehicle condition registration
RegisterNetEvent("Server:VehiclePersistence:RegisterCondition", function(netId, plate, condition, modifications)
    print("Registering vehicle: " .. plate)
    print("Condition data received from client")
end)
```

## Related Events

- [Server:VehiclePersistence:UpdateCondition](ig_event_VehiclePersistenceUpdateCondition.md) - Update condition on vehicle exit
- [vehicle:persistence:registered](ig_event_VehiclePersistenceRegistered.md) - Server notification to client
- [Server:Vehicle:OnPlayerEntered](ig_event_ServerOnPlayerEnteredVehicle.md) - Internal vehicle entry event

## Source

Triggered from: `client/[Events]/_vehicle.lua` (Line ~20)
Registered in: `server/[Events]/_vehicle.lua`

## Security Notes

- **Server-Authoritative State**: The server reads vehicle statebag directly from the entity
- Client sends ONLY: identifiers (netId, plate) + visual state (condition, mods)
- Client does NOT send: statebag (server-hosted state - prevented for security)
- Server verifies netId and reads statebag via `NetworkGetEntityFromNetworkId()`

## Persistence Flow

1. Client detects player entering vehicle
2. Client captures current vehicle condition and modifications
3. Client sends `Server:VehiclePersistence:RegisterCondition` to server
4. Server reads complete statebag from vehicle entity (authoritative)
5. Server stores vehicle in cache and database
6. Server sends confirmation via `vehicle:persistence:registered`

## Notes

- Fired automatically when player enters a vehicle
- Replaces old polling-based vehicle detection
- Event-driven architecture ensures minimal CPU usage
- Condition and modifications data format must match ig.func utilities

