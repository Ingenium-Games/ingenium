# ig.func.GetPlayersInArea

## Description

Returns all player peds within a specified radius of the given coordinates. Set minimal to true for just entity IDs, or false for detailed information including models and coordinates.

## Signature

```lua
function ig.func.GetPlayersInArea(ords, radius, minimal)
```

## Parameters

- **`ords`**: table "Generally a {x,y,z} or vec3
- **`radius`**: number "Radius to return objects within
- **`minimal`**: boolean "Return just the found objects or their model and coords as well?

## Example

```lua
-- Example 1: Get players in minimal format (just entity IDs)
local coords = vector3(100.0, 200.0, 30.0)
local players = ig.func.GetPlayersInArea(coords, 50.0, true)
for _, player in ipairs(players) do
    print("Found player entity:", player)
end

-- Example 2: Get detailed player info
local playersDetailed = ig.func.GetPlayersInArea(coords, 50.0, false)
for entityId, data in pairs(playersDetailed) do
    print("Player:", entityId, "Model:", data.Model, "At:", data.Coords)
end

-- Example 3: Find closest player in area
local nearbyPlayers = ig.func.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 25.0, true)
if #nearbyPlayers > 0 then
    print("Found", #nearbyPlayers, "players nearby")
end
```

## Important Notes

> 📋 **Parameter**: `minimal` - When set to `true`, returns simplified data structure

## Related Functions

- [ig.func.ClearInterval](ig_func_ClearInterval.md)
- [ig.func.CompareCoords](ig_func_CompareCoords.md)
- [ig.func.CreateObject](ig_func_CreateObject.md)
- [ig.func.CreatePed](ig_func_CreatePed.md)

## Source

Defined in: `client/_functions.lua`
