# ig.sql.banking.AddBankOffline

## Description

Adds money to a character's bank account when they are offline. Uses direct SQL update with JSON manipulation.

## Signature

```lua
function ig.sql.banking.AddBankOffline(characterId, amount)
```

## Parameters

- **`characterId`**: string - The Character_ID to add bank balance to
- **`amount`**: number - Amount to add to the bank account

## Returns

None

## Example

```lua
-- Add money to offline character's bank
local recipientId = "ABC123XYZ789"
ig.sql.banking.AddBankOffline(recipientId, 500.00)

-- Use in transfer to offline player
local function TransferToOfflinePlayer(senderId, recipientIban, amount)
    local xSender = ig.data.GetPlayer(senderId)
    
    -- Get recipient character
    local recipient = ig.sql.char.GetByIban(recipientIban)
    if not recipient then
        return false, "Invalid IBAN"
    end
    
    -- Check if recipient is online
    local xRecipient = ig.data.GetPlayerByCharacterId(recipient.Character_ID)
    
    if xRecipient then
        -- Online - use direct method
        xRecipient.AddBank(amount)
    else
        -- Offline - use SQL update
        ig.sql.banking.AddBankOffline(recipient.Character_ID, amount)
    end
    
    -- Deduct from sender
    xSender.RemoveBank(amount)
    
    return true
end
```

## Related Functions

- [xPlayer.AddBank](xPlayer_AddBank.md)
- [ig.sql.char.GetByIban](ig_sql_char_GetByIban.md)
- [ig.data.GetPlayerByCharacterId](ig_data_GetPlayerByCharacterId.md)

## Notes

- Uses JSON_SET and COALESCE for safe SQL manipulation
- Handles cases where Bank field might be NULL
- Does not trigger dirty flag or state updates (player is offline)
- Character will see updated balance when they next log in
- Use this instead of xPlayer.AddBank() for offline characters

## Source

Defined in: `server/[SQL]/_banking.lua`
