# ig.player.GetPlayerByCharacterId

## Description

Retrieves an online player by their Character_ID. Searches through all active players to find a match.

## Signature

```lua
function ig.player.GetPlayerByCharacterId(characterId)
```

## Parameters

- **`characterId`**: string - The Character_ID to search for

## Returns

- **`table`**: xPlayer object if found, `nil` if not found or player is offline

## Example

```lua
-- Find an online player by Character_ID
local characterId = "ABC123XYZ789"
local xPlayer = ig.player.GetPlayerByCharacterId(characterId)

if xPlayer then
    print("Player is online: " .. xPlayer.GetFull_Name())
    print("Server ID: " .. xPlayer.GetID())
    xPlayer.Notify("You have a pending notification", "blue", 5000)
else
    print("Player is offline")
end

-- Check if transfer recipient is online
local function NotifyTransferRecipient(recipientId, senderName, amount)
    local xRecipient = ig.player.GetPlayerByCharacterId(recipientId)
    
    if xRecipient then
        -- Player is online, notify them
        xRecipient.Notify(
            string.format("You received $%s from %s", amount, senderName),
            "green",
            5000
        )
        
        -- Update their NUI if banking is open
        TriggerClientEvent("banking:addTransaction", xRecipient.GetID(), {
            type = "Transfer In",
            description = "From " .. senderName,
            amount = amount,
            date = os.date("%Y-%m-%d %H:%M:%S")
        })
    end
    
    -- If offline, they'll see the transaction when they log in
end
```

## Related Functions

- [ig.data.GetPlayer](ig_data_GetPlayer.md)
- [ig.data.GetPlayers](ig_data_GetPlayers.md)
- [ig.sql.char.Get](ig_sql_char_Get.md)
- [xPlayer.GetCharacter_ID](xPlayer_GetCharacter_ID.md)

## Notes

- Only returns online players (those in ig.pdex)
- Returns nil if player is offline or Character_ID not found
- Useful for determining if a transfer recipient is online
- More efficient than querying database for online status

## Source

Defined in: `server/[Objects]/_players.lua`
