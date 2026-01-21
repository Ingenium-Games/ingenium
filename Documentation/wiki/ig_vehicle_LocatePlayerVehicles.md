# ig.vehicle.LocatePlayerVehicles

## Description

Creates map blips for all vehicles owned by a specific player character to help them locate their vehicles.

## Signature

```lua
function ig.vehicle.LocatePlayerVehicles(playerId, characterId)
```

## Parameters

- **`playerId`**: number - The player source ID
- **`characterId`**: number - The character ID

## Returns

None

## Behavior

- Queries database for player's vehicles
- Creates temporary blips on the map for each vehicle
- Sends blip data to client for display

## Example

```lua
-- Locate all vehicles for a player
local xPlayer = ig.data.GetPlayer(source)
ig.vehicle.LocatePlayerVehicles(source, xPlayer.GetCharacterId())
```

## Source

Defined in: `server/[Commands]/_locate_vehicles.lua`
