# ig.event.Client:LeftVehicle

## Description

Fired locally on the client when a player exits a vehicle. This event is triggered by the game event system when the player's character leaves any seat in a vehicle.

**Scope:** Client-side local event
**Resource:** Ingenium
**Namespace:** Client Events

## Signature

```lua
RegisterNetEvent("Client:LeftVehicle", function(vehicle, seat, vehicleName, netId) end)
```

## Parameters

- **`vehicle`**: `number` - The entity handle of the vehicle
- **`seat`**: `number` - The seat index the player left from (-1 = driver seat, 0+ = passenger seats)
- **`vehicleName`**: `string` - Display name of the vehicle model
- **`netId`**: `number` - Network ID of the vehicle entity

## Returns

None

## Example

```lua
-- Listen for when player exits any vehicle
RegisterNetEvent("Client:LeftVehicle", function(vehicle, seat, vehicleName, netId)
    print("Left vehicle: " .. vehicleName .. " from seat " .. seat)
    print("Network ID: " .. netId)
end)
```

## Related Events

- [Client:EnteredVehicle](ig_event_ClientEnteredVehicle.md) - Fired when player enters a vehicle
- [Server:Vehicle:PlayerLeft](ig_event_ServerPlayerLeftVehicle.md) - Server-side equivalent
- [Server:Vehicle:OnPlayerLeft](ig_event_ServerOnPlayerLeftVehicle.md) - Server-side internal event

## Source

Triggered from: `client/[Events]/_vehicle.lua` (Line ~51)
Fires to: Local event handlers only

## Notes

- This is a LOCAL client-side event, not replicated to server
- Use this for client-side vehicle exit logic (UI cleanup, state resets, etc.)
- For server-side logic, see `Server:Vehicle:PlayerLeft` or `Server:Vehicle:OnPlayerLeft`
- The event is fired via `gameEventTriggered` system using `CEventNetworkPlayerLeftVehicle`

