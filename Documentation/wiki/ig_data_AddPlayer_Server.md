# ig.data.AddPlayer (Server)

## Description

Wrapper function that initializes a player slot in the player index. Calls `ig.player.AddPlayer()`.

## Signature

```lua
function ig.data.AddPlayer(src)
```

## Parameters

- **`src`**: number - The player's server ID (source)

## Returns

None

## Example

```lua
-- This function is typically used internally during player connection
-- You generally should not need to call this directly

-- Example from player connection handler
RegisterServerCallback({
    eventName = "Server:PlayerConnecting",
    eventCallback = function(source)
        local src = tonumber(source)
        local License_ID = ig.func.identifier(src)
        
        if License_ID then
            -- Initialize player slot
            ig.data.AddPlayer(src)
            
            -- Check if user exists in database
            local exists = ig.sql.user.Find(License_ID)
            
            if not exists then
                -- Create new user
                ig.sql.user.Add(...)
            else
                -- Update existing user
                ig.sql.user.Update(...)
            end
            
            return { success = true }
        else
            return { success = false, error = "No license identifier" }
        end
    end
})
```

## Related Functions

- [ig.data.RemovePlayer](ig_data_RemovePlayer_Server.md)
- [ig.data.SetPlayer](ig_data_SetPlayer_Server.md)
- [ig.player.AddPlayer](ig_player_AddPlayer.md)

## Notes

- This is a server-side function (wrapper for ig.player.AddPlayer)
- Sets the player slot to `false` initially
- Must be called before SetPlayer can be used
- Called during player connection, before character selection

## Source

Defined in: `server/_data.lua`
