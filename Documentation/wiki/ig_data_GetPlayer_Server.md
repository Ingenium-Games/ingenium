# ig.data.GetPlayer (Server)

## Description

Wrapper function that retrieves an xPlayer object by their server ID (source). Calls `ig.player.GetPlayer()`.

## Signature

```lua
function ig.data.GetPlayer(src)
```

## Parameters

- **`src`**: number - The player's server ID (source)

## Returns

- **`table`**: xPlayer object if found, `false` if not found

## Example

```lua
-- Get player in a command
RegisterCommand("balance", function(source, args)
    local xPlayer = ig.data.GetPlayer(source)
    
    if xPlayer then
        local balance = xPlayer.GetBank()
        xPlayer.Notify("Your bank balance is: $" .. balance, "blue", 5000)
    end
end)

-- Get player in an event handler
RegisterNetEvent("Server:Banking:CheckBalance")
AddEventHandler("Server:Banking:CheckBalance", function()
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        return
    end
    
    local bankBalance = xPlayer.GetBank()
    local cashBalance = xPlayer.GetCash()
    
    TriggerClientEvent("Client:Banking:BalanceResponse", src, {
        bank = bankBalance,
        cash = cashBalance
    })
end)

-- Get player in a callback
RegisterServerCallback({
    eventName = "GetPlayerData",
    eventCallback = function(source)
        local xPlayer = ig.data.GetPlayer(source)
        
        if not xPlayer then
            return nil
        end
        
        return {
            name = xPlayer.GetFull_Name(),
            bank = xPlayer.GetBank(),
            cash = xPlayer.GetCash(),
            job = xPlayer.GetJob()
        }
    end
})
```

## Related Functions

- [ig.data.GetPlayers](ig_data_GetPlayers_Server.md)
- [ig.player.GetPlayer](ig_player_GetPlayer.md)
- [ig.data.GetPlayerByCharacterId](ig_data_GetPlayerByCharacterId.md)

## Notes

- This is a server-side function (wrapper for ig.player.GetPlayer)
- Returns `false` (not nil) if player not found
- Player must be fully loaded (after character selection)
- Returns xPlayer object with all character data and methods

## Source

Defined in: `server/_data.lua`
