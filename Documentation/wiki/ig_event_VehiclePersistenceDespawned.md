# ig.event.vehicle:persistence:despawned

## Description

Network event sent from server to client as notification that a persistent vehicle has been despawned or removed from the world. Part of the vehicle persistence notification system.

**Scope:** Client-side network event
**Resource:** Ingenium
**Direction:** Server → Client
**Namespace:** Vehicle Persistence Events (Notifications)

## Signature

```lua
RegisterNetEvent("vehicle:persistence:despawned", function(plate) end)
```

## Parameters

- **`plate`**: `string` - Vehicle license plate that was despawned

## Returns

None

## Example

```lua
-- Client receives despawn notification
RegisterNetEvent("vehicle:persistence:despawned", function(plate)
    print("Persistent vehicle despawned: " .. plate)
end)
```

## Related Events

- [vehicle:persistence:spawned](ig_event_VehiclePersistenceSpawned.md) - Vehicle spawn notification
- [vehicle:persistence:registered](ig_event_VehiclePersistenceRegistered.md) - Vehicle registration confirmation
- [vehicle:persistence:updated](ig_event_VehiclePersistenceUpdated.md) - Vehicle update confirmation

## Source

Triggered from: `server/_vehicle_persistence.lua` or persistence cleanup system
Received by: `client/_vehicle_persistence.lua`

## Purpose

- **User Notification**: Informs player that their vehicle has been removed/stored
- **Cleanup Confirmation**: Confirms that persistent vehicle despawn was handled
- **State Awareness**: Client knows vehicle is no longer in the world

## Notes

- This is a NOTIFICATION event from server to client
- Fired when a persistent vehicle is despawned or cleaned up
- Used for UI feedback or notifications to the player
- Part of the non-critical notification flow

