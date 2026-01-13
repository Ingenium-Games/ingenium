# ig.event.Server:Vehicle:OnPlayerEntered

## Description

Internal server-side event fired when a player enters a vehicle. This is a callback event triggered after `Server:Vehicle:PlayerEntered` completes. Used by the vehicle persistence system to register and track vehicles.

**Scope:** Server-side internal event
**Resource:** Ingenium
**Namespace:** Server Events (Internal)

## Signature

```lua
AddEventHandler("Server:Vehicle:OnPlayerEntered", function(playerId, vehicleEntity, seat, netId) end)
```

## Parameters

- **`playerId`**: `number` - Server ID of the player
- **`vehicleEntity`**: `number` - Entity handle of the vehicle
- **`seat`**: `number` - The seat index (-1 = driver seat, 0+ = passenger seats)
- **`netId`**: `number` - Network ID of the vehicle entity

## Returns

None

## Example

```lua
-- Hook into vehicle entry for persistence or custom logic
AddEventHandler("Server:Vehicle:OnPlayerEntered", function(playerId, vehicleEntity, seat, netId)
    local plate = GetVehicleNumberPlateText(vehicleEntity)
    print("Player " .. playerId .. " in vehicle: " .. plate)
end)
```

## Related Events

- [Server:Vehicle:OnPlayerLeft](ig_event_ServerOnPlayerLeftVehicle.md) - Fired when player leaves vehicle
- [Server:Vehicle:PlayerEntered](ig_event_ServerPlayerEnteredVehicle.md) - Network event that triggers this
- [Client:EnteredVehicle](ig_event_ClientEnteredVehicle.md) - Client-side event source

## Source

Triggered from: `server/[Events]/_vehicle.lua` (Line ~23)
Used by: Vehicle persistence system in `server/_vehicle_persistence.lua`

## Important

This is an INTERNAL event used by the framework. It provides:
- Direct vehicle entity reference (not just network ID)
- Player server ID with authenticated context
- Hook point for persistence system registration

## Notes

- Used by vehicle persistence system to register vehicles
- Has access to actual vehicle entity (not just network ID)
- Fired on every vehicle enter, including NPCs and AI
- Can be used for analytics, logging, or custom vehicle tracking

