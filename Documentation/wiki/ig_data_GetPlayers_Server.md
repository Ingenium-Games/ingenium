# ig.data.GetPlayers (Server)

## Description

Wrapper function that returns all active players on the server. Calls `ig.player.GetPlayers()`.

## Signature

```lua
function ig.data.GetPlayers()
```

## Parameters

None

## Returns

- **`table`**: The player index table (ig.pdex) containing all active xPlayer objects, keyed by server ID

## Example

```lua
-- Get all active players
local players = ig.data.GetPlayers()

for serverId, xPlayer in pairs(players) do
    if xPlayer then
        print(string.format("Player %d: %s", serverId, xPlayer.GetFull_Name()))
    end
end

-- Count active players
local function CountActivePlayers()
    local count = 0
    local players = ig.data.GetPlayers()
    
    for k, v in pairs(players) do
        if v then
            count = count + 1
        end
    end
    
    return count
end

-- Notify all players
local function NotifyAllPlayers(message, color, duration)
    local players = ig.data.GetPlayers()
    
    for serverId, xPlayer in pairs(players) do
        if xPlayer then
            xPlayer.Notify(message, color, duration)
        end
    end
end
```

## Related Functions

- [ig.data.GetPlayer](ig_data_GetPlayer_Server.md)
- [ig.player.GetPlayers](ig_player_GetPlayers.md)
- [ig.data.GetPlayerByCharacterId](ig_data_GetPlayerByCharacterId.md)

## Notes

- This is a server-side function (wrapper for ig.player.GetPlayers)
- Returns the player index table (ig.pdex)
- Players are keyed by their server ID (source)
- Only includes currently connected players
- Some entries may be `false` if player disconnected

## Source

Defined in: `server/_data.lua`
