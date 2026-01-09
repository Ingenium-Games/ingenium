# xPlayer.GetIban

## Description

Returns the character's IBAN (International Bank Account Number) used for banking transactions and transfers.

## Signature

```lua
function xPlayer.GetIban()
```

## Parameters

None

## Returns

- **`string`**: The character's 9-digit IBAN

## Example

```lua
-- Get a player's IBAN
local xPlayer = ig.data.GetPlayer(source)
local iban = xPlayer.GetIban()
print("Player IBAN: " .. iban)

-- Use in banking operations
if iban then
    print("Account holder: " .. xPlayer.GetFull_Name())
    print("IBAN: " .. iban)
end
```

## Related Functions

- [xPlayer.GetBank](xPlayer_GetBank.md)
- [xPlayer.AddBank](xPlayer_AddBank.md)
- [xPlayer.RemoveBank](xPlayer_RemoveBank.md)
- [ig.sql.char.GetByIban](ig_sql_char_GetByIban.md)

## Notes

- The IBAN is stored in the character's state and synced to clients
- Each character has a unique IBAN assigned during character creation
- Used primarily for character-to-character bank transfers

## Source

Defined in: `server/[Classes]/_player.lua`
