# ig.data.RemovePlayer (Server)

## Description

Wrapper function that removes a player from the player index for garbage collection. Calls `ig.player.RemovePlayer()`.

## Signature

```lua
function ig.data.RemovePlayer(src)
```

## Parameters

- **`src`**: number - The player's server ID (source)

## Returns

None

## Example

```lua
-- This function is typically used internally during player disconnection
-- You generally should not need to call this directly

-- Example from player disconnect handler
AddEventHandler("playerDropped", function()
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if xPlayer then
        -- Save player data
        ig.sql.save.User(xPlayer, function()
            ig.sql.char.SetActive(xPlayer.GetIdentifier(), false, function()
                -- Remove player from index
                ig.data.RemovePlayer(src)
                
                print("Player " .. xPlayer.GetFull_Name() .. " disconnected")
            end)
        end)
    end
end)

-- Advanced: Force remove a player
local function ForceRemovePlayer(source, reason)
    local xPlayer = ig.data.GetPlayer(source)
    
    if xPlayer then
        -- Log the removal
        print(string.format("Force removing player %s: %s", 
            xPlayer.GetFull_Name(), 
            reason))
        
        -- Save their data
        ig.sql.save.User(xPlayer)
        
        -- Remove from index
        ig.data.RemovePlayer(source)
        
        -- Kick from server
        DropPlayer(source, reason)
    end
end
```

## Related Functions

- [ig.data.AddPlayer](ig_data_AddPlayer_Server.md)
- [ig.data.GetPlayer](ig_data_GetPlayer_Server.md)
- [ig.player.RemovePlayer](ig_player_RemovePlayer.md)

## Notes

- This is a server-side function (wrapper for ig.player.RemovePlayer)
- Sets the player slot to `nil` for garbage collection
- Should be called after saving player data
- Called automatically on player disconnect

## Source

Defined in: `server/_data.lua`
