# ig.sql.char.GetByIban

## Description

Retrieves a character record from the database by their IBAN (International Bank Account Number).

## Signature

```lua
function ig.sql.char.GetByIban(iban, cb)
```

## Parameters

- **`iban`**: string - The 9-digit IBAN to search for
- **`cb`**: function (optional) - Callback function that receives the character data

## Returns

- **`table`**: Character data object or `nil` if not found

## Example

```lua
-- Get character by IBAN (synchronous)
local targetCharacter = ig.sql.char.GetByIban("123456789")
if targetCharacter then
    print("Found character: " .. targetCharacter.First_Name .. " " .. targetCharacter.Last_Name)
    print("Character ID: " .. targetCharacter.Character_ID)
else
    print("No character found with that IBAN")
end

-- Get character by IBAN (with callback)
ig.sql.char.GetByIban("123456789", function(character)
    if character then
        print("Character found: " .. character.First_Name)
    end
end)

-- Use in banking transfer validation
local function ValidateTransferRecipient(iban)
    local recipient = ig.sql.char.GetByIban(iban)
    if not recipient then
        return false, "Invalid IBAN - Account not found"
    end
    return true, recipient
end
```

## Related Functions

- [ig.sql.char.Get](ig_sql_char_Get.md)
- [xPlayer.GetIban](xPlayer_GetIban.md)
- [ig.sql.banking.AddBankOffline](ig_sql_banking_AddBankOffline.md)

## Notes

- Uses parameterized SQL query for security
- Returns the full character record including all columns
- Useful for validating transfer recipients
- IBAN field is indexed for fast lookups

## Source

Defined in: `server/[SQL]/_character.lua`
