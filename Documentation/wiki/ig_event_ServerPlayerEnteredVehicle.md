# ig.event.Server:Vehicle:PlayerEntered

## Description

Fired on the server when a player enters a vehicle. This event is registered by the client and triggers server-side vehicle entry logic, updating player state and triggering internal server events.

**Scope:** Server-side network event
**Resource:** Ingenium
**Direction:** Client → Server
**Namespace:** Server Events

## Signature

```lua
RegisterNetEvent("Server:Vehicle:PlayerEntered", function(netId, seat, vehicleName) end)
```

## Parameters

- **`netId`**: `number` - Network ID of the vehicle entity
- **`seat`**: `number` - The seat index (-1 = driver seat, 0+ = passenger seats)
- **`vehicleName`**: `string` - Display name of the vehicle model

## Returns

None

## Example

```lua
-- Server receives player vehicle entry notification
RegisterNetEvent("Server:Vehicle:PlayerEntered", function(netId, seat, vehicleName)
    local source = source  -- Player server ID
    print("Player " .. source .. " entered " .. vehicleName)
end)
```

## Related Events

- [Server:Vehicle:PlayerLeft](ig_event_ServerPlayerLeftVehicle.md) - Fired when player leaves vehicle
- [Server:Vehicle:OnPlayerEntered](ig_event_ServerOnPlayerEnteredVehicle.md) - Internal server event triggered after
- [Client:EnteredVehicle](ig_event_ClientEnteredVehicle.md) - Client-side event that triggers this

## Source

Triggered from: `client/[Events]/_vehicle.lua` (Line ~37)
Registered in: `server/[Events]/_vehicle.lua` (Line ~8)

## Side Effects

When this event fires on the server:
1. Player state is updated: `InVehicle = true`, `VehicleSeat = seat`, `Vehicle = netId`
2. Internal server event `Server:Vehicle:OnPlayerEntered` is triggered
3. Vehicle persistence system may register or update vehicle tracking
4. Any custom server-side vehicle entry handlers will execute

## Notes

- This is a NETWORK event sent from client to server
- Should be used for server-side authorization and state tracking
- The vehicle entity is retrieved from netId using `NetworkGetEntityFromNetworkId()`
- Persistence system hooks into `Server:Vehicle:OnPlayerEntered` for vehicle tracking

