# ig.data.GetPlayerByCharacterId

## Description

Wrapper function that retrieves an online player by their Character_ID. Calls `ig.player.GetPlayerByCharacterId()`.

## Signature

```lua
function ig.data.GetPlayerByCharacterId(characterId)
```

## Parameters

- **`characterId`**: string - The Character_ID to search for

## Returns

- **`table`**: xPlayer object if found, `nil` if not found or player is offline

## Example

```lua
-- Find an online player by Character_ID
local characterId = "ABC123XYZ789"
local xPlayer = ig.data.GetPlayerByCharacterId(characterId)

if xPlayer then
    print("Player is online: " .. xPlayer.GetFull_Name())
    xPlayer.Notify("Message sent!", "green", 3000)
else
    print("Player is offline")
end

-- Use in banking transfer
local function ProcessTransfer(senderId, targetIban, amount)
    local xSender = ig.data.GetPlayer(senderId)
    local targetChar = ig.sql.char.GetByIban(targetIban)
    
    if not targetChar then
        return false, "Invalid IBAN"
    end
    
    -- Check if target is online
    local xTarget = ig.data.GetPlayerByCharacterId(targetChar.Character_ID)
    
    if xTarget then
        -- Online: direct update
        xTarget.AddBank(amount)
        xTarget.Notify("You received $" .. amount, "green", 5000)
    else
        -- Offline: SQL update
        ig.sql.banking.AddBankOffline(targetChar.Character_ID, amount)
    end
    
    xSender.RemoveBank(amount)
    return true
end
```

## Related Functions

- [ig.player.GetPlayerByCharacterId](ig_player_GetPlayerByCharacterId.md)
- [ig.data.GetPlayer](ig_data_GetPlayer.md)
- [ig.data.GetPlayers](ig_data_GetPlayers.md)
- [xPlayer.GetCharacter_ID](xPlayer_GetCharacter_ID.md)

## Notes

- This is a wrapper around `ig.player.GetPlayerByCharacterId()`
- Only returns online players
- Returns nil if player is offline
- Part of the ig.data API for consistency with other player data functions

## Source

Defined in: `server/_data.lua`
