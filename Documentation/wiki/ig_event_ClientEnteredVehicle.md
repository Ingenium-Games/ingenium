# ig.event.Client:EnteredVehicle

## Description

Fired locally on the client when a player enters a vehicle. This event is triggered by the game event system when the player's character enters a vehicle seat.

**Scope:** Client-side local event
**Resource:** Ingenium
**Namespace:** Client Events

## Signature

```lua
RegisterNetEvent("Client:EnteredVehicle", function(vehicle, seat, vehicleName, netId) end)
```

## Parameters

- **`vehicle`**: `number` - The entity handle of the vehicle
- **`seat`**: `number` - The seat index (-1 = driver seat, 0+ = passenger seats)
- **`vehicleName`**: `string` - Display name of the vehicle model
- **`netId`**: `number` - Network ID of the vehicle entity

## Returns

None

## Example

```lua
-- Listen for when player enters any vehicle
RegisterNetEvent("Client:EnteredVehicle", function(vehicle, seat, vehicleName, netId)
    print("Entered vehicle: " .. vehicleName .. " in seat " .. seat)
    print("Network ID: " .. netId)
end)
```

## Related Events

- [Client:LeftVehicle](ig_event_ClientLeftVehicle.md) - Fired when player leaves a vehicle
- [Server:Vehicle:PlayerEntered](ig_event_ServerPlayerEnteredVehicle.md) - Server-side equivalent
- [Server:Vehicle:OnPlayerEntered](ig_event_ServerOnPlayerEnteredVehicle.md) - Server-side internal event

## Source

Triggered from: `client/[Events]/_vehicle.lua` (Line ~28)
Fires to: Local event handlers only

## Notes

- This is a LOCAL client-side event, not replicated to server
- Use this for client-side vehicle entry logic (UI updates, animations, etc.)
- For server-side logic, see `Server:Vehicle:PlayerEntered` or `Server:Vehicle:OnPlayerEntered`
- The event is fired via `gameEventTriggered` system using `CEventNetworkPlayerEnteredVehicle`

