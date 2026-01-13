# ig.event.vehicle:persistence:spawned

## Description

Network event sent from server to client as notification that a persistent vehicle has been spawned. Part of the vehicle persistence notification system for informing clients when saved vehicles are restored.

**Scope:** Client-side network event
**Resource:** Ingenium
**Direction:** Server → Client
**Namespace:** Vehicle Persistence Events (Notifications)

## Signature

```lua
RegisterNetEvent("vehicle:persistence:spawned", function(plate) end)
```

## Parameters

- **`plate`**: `string` - Vehicle license plate that was spawned

## Returns

None

## Example

```lua
-- Client receives spawn notification
RegisterNetEvent("vehicle:persistence:spawned", function(plate)
    print("Persistent vehicle spawned: " .. plate)
end)
```

## Related Events

- [vehicle:persistence:despawned](ig_event_VehiclePersistenceDespawned.md) - Vehicle despawn notification
- [vehicle:persistence:registered](ig_event_VehiclePersistenceRegistered.md) - Vehicle registration confirmation
- [vehicle:persistence:updated](ig_event_VehiclePersistenceUpdated.md) - Vehicle update confirmation

## Source

Triggered from: `server/_vehicle_persistence.lua` or persistence spawn system
Received by: `client/_vehicle_persistence.lua`

## Purpose

- **User Notification**: Informs player that their saved vehicle has been restored
- **Vehicle Restoration**: Confirms that persistent vehicle spawn was successful
- **State Awareness**: Client knows vehicle is now available in the world

## Notes

- This is a NOTIFICATION event from server to client
- Fired when a persistent vehicle is spawned/restored
- Used for UI feedback or notifications to the player
- Part of the non-critical notification flow (vs critical registration)

