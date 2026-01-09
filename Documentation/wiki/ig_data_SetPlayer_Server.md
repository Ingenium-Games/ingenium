# ig.data.SetPlayer (Server)

## Description

Wrapper function that stores an xPlayer object in the player index. Calls `ig.player.SetPlayer()`.

## Signature

```lua
function ig.data.SetPlayer(src, data)
```

## Parameters

- **`src`**: number - The player's server ID (source)
- **`data`**: table - The xPlayer object to store

## Returns

None

## Example

```lua
-- This function is typically used internally during player loading
-- You generally should not need to call this directly

-- Example from player loading
function ig.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    local xPlayer = ig.class.Player(src, Character_ID)
    
    -- Store the player in the index
    ig.data.SetPlayer(src, xPlayer)
    
    TriggerClientEvent("Client:Character:Loaded", src)
end

-- Advanced: Reload a player's data
local function ReloadPlayerData(source)
    local oldPlayer = ig.data.GetPlayer(source)
    
    if not oldPlayer then
        return false
    end
    
    local characterId = oldPlayer.GetCharacter_ID()
    
    -- Create new player instance
    local newPlayer = ig.class.Player(source, characterId)
    
    -- Update the index
    ig.data.SetPlayer(source, newPlayer)
    
    return true
end
```

## Related Functions

- [ig.data.GetPlayer](ig_data_GetPlayer_Server.md)
- [ig.data.RemovePlayer](ig_data_RemovePlayer_Server.md)
- [ig.player.SetPlayer](ig_player_SetPlayer.md)
- [ig.class.Player](ig_class_Player.md)

## Notes

- This is a server-side function (wrapper for ig.player.SetPlayer)
- Used internally during player loading
- Overwrites any existing player data at that server ID
- Should only be called after creating a valid xPlayer object

## Source

Defined in: `server/_data.lua`
