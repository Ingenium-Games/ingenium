# ig.event.Server:Vehicle:PlayerLeft

## Description

Fired on the server when a player exits a vehicle. This event is registered by the client and triggers server-side vehicle exit logic, updating player state and clearing vehicle associations.

**Scope:** Server-side network event
**Resource:** Ingenium
**Direction:** Client → Server
**Namespace:** Server Events

## Signature

```lua
RegisterNetEvent("Server:Vehicle:PlayerLeft", function(netId, seat, vehicleName) end)
```

## Parameters

- **`netId`**: `number` - Network ID of the vehicle entity the player left
- **`seat`**: `number` - The seat index player left from (-1 = driver seat, 0+ = passenger seats)
- **`vehicleName`**: `string` - Display name of the vehicle model

## Returns

None

## Example

```lua
-- Server receives player vehicle exit notification
RegisterNetEvent("Server:Vehicle:PlayerLeft", function(netId, seat, vehicleName)
    local source = source  -- Player server ID
    print("Player " .. source .. " left " .. vehicleName)
end)
```

## Related Events

- [Server:Vehicle:PlayerEntered](ig_event_ServerPlayerEnteredVehicle.md) - Fired when player enters vehicle
- [Server:Vehicle:OnPlayerLeft](ig_event_ServerOnPlayerLeftVehicle.md) - Internal server event triggered after
- [Client:LeftVehicle](ig_event_ClientLeftVehicle.md) - Client-side event that triggers this

## Source

Triggered from: `client/[Events]/_vehicle.lua` (Line ~52)
Registered in: `server/[Events]/_vehicle.lua` (Line ~30)

## Side Effects

When this event fires on the server:
1. Player state is updated: `InVehicle = false`, `VehicleSeat = -1`, `Vehicle = 0`
2. Internal server event `Server:Vehicle:OnPlayerLeft` is triggered
3. Vehicle persistence system may update or clean up vehicle tracking
4. Any custom server-side vehicle exit handlers will execute

## Notes

- This is a NETWORK event sent from client to server
- Should be used for server-side cleanup and state management
- Player state variables are reset when this event fires
- Persistence system hooks into `Server:Vehicle:OnPlayerLeft` for vehicle state updates

