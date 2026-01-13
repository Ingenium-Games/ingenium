# ig.event.vehicle:persistence:registered

## Description

Network event sent from server to client as notification that a vehicle has been successfully registered in the persistence system. Client receives this after sending `Server:VehiclePersistence:RegisterCondition`.

**Scope:** Client-side network event
**Resource:** Ingenium
**Direction:** Server → Client
**Namespace:** Vehicle Persistence Events (Notifications)

## Signature

```lua
RegisterNetEvent("vehicle:persistence:registered", function(plate) end)
```

## Parameters

- **`plate`**: `string` - Vehicle license plate that was registered

## Returns

None

## Example

```lua
-- Client receives registration confirmation
RegisterNetEvent("vehicle:persistence:registered", function(plate)
    print("Vehicle " .. plate .. " registered in persistence system")
end)
```

## Related Events

- [Server:VehiclePersistence:RegisterCondition](ig_event_VehiclePersistenceRegisterCondition.md) - Triggers this response
- [vehicle:persistence:updated](ig_event_VehiclePersistenceUpdated.md) - Update confirmation
- [vehicle:persistence:spawned](ig_event_VehiclePersistenceSpawned.md) - Vehicle spawn notification
- [vehicle:persistence:despawned](ig_event_VehiclePersistenceDespawned.md) - Vehicle despawn notification

## Source

Triggered from: `server/[Events]/_vehicle.lua` or `server/_vehicle_persistence.lua`
Received by: `client/_vehicle_persistence.lua`

## Purpose

- **User Feedback**: Provides confirmation that vehicle state was saved
- **State Synchronization**: Ensures client knows persistence system has registered the vehicle
- **Debug/Logging**: Can be used for vehicle persistence debugging

## Notes

- This is a NOTIFICATION event from server to client
- Part of the feedback mechanism for the persistence system
- Used in `client/_vehicle_persistence.lua` for logging/display
- Completes the registration handshake

