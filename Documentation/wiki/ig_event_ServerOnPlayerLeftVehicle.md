# ig.event.Server:Vehicle:OnPlayerLeft

## Description

Internal server-side event fired when a player exits a vehicle. This is a callback event triggered after `Server:Vehicle:PlayerLeft` completes. Used by the vehicle persistence system to update vehicle state and persistence data.

**Scope:** Server-side internal event
**Resource:** Ingenium
**Namespace:** Server Events (Internal)

## Signature

```lua
AddEventHandler("Server:Vehicle:OnPlayerLeft", function(playerId, netId, seat) end)
```

## Parameters

- **`playerId`**: `number` - Server ID of the player
- **`netId`**: `number` - Network ID of the vehicle the player left
- **`seat`**: `number` - The seat index player left from (-1 = driver seat, 0+ = passenger seats)

## Returns

None

## Example

```lua
-- Hook into vehicle exit for persistence or custom logic
AddEventHandler("Server:Vehicle:OnPlayerLeft", function(playerId, netId, seat)
    local vehicleEntity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicleEntity) then
        local plate = GetVehicleNumberPlateText(vehicleEntity)
        print("Player " .. playerId .. " left vehicle: " .. plate)
    end
end)
```

## Related Events

- [Server:Vehicle:OnPlayerEntered](ig_event_ServerOnPlayerEnteredVehicle.md) - Fired when player enters vehicle
- [Server:Vehicle:PlayerLeft](ig_event_ServerPlayerLeftVehicle.md) - Network event that triggers this
- [Client:LeftVehicle](ig_event_ClientLeftVehicle.md) - Client-side event source

## Source

Triggered from: `server/[Events]/_vehicle.lua` (Line ~42)
Used by: Vehicle persistence system in `server/_vehicle_persistence.lua`

## Important

This is an INTERNAL event used by the framework. It provides:
- Player server ID with authenticated context
- Network ID for vehicle lookup
- Hook point for persistence system updates

## Notes

- Used by vehicle persistence system to finalize vehicle state
- Requires converting netId to entity via `NetworkGetEntityFromNetworkId()`
- Fired on every vehicle exit, including NPCs and AI
- Can be used for analytics, logging, or custom vehicle cleanup

