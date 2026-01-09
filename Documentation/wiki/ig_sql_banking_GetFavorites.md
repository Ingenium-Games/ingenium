# ig.sql.banking.GetFavorites

## Description

Retrieves saved favorite payees for a character from their Banking_Favorites field.

## Signature

```lua
function ig.sql.banking.GetFavorites(characterId)
```

## Parameters

- **`characterId`**: string - The Character_ID to get favorites for

## Returns

- **`table`**: Array of favorite objects, each containing:
  - `iban`: string - The recipient's IBAN
  - `name`: string - Friendly name for the recipient

## Example

```lua
-- Get favorites for a character
local xPlayer = ig.data.GetPlayer(source)
local favorites = ig.sql.banking.GetFavorites(xPlayer.GetCharacter_ID())

for i, favorite in ipairs(favorites) do
    print(string.format("%s - IBAN: %s", favorite.name, favorite.iban))
end

-- Send favorites to banking NUI
TriggerClientEvent("banking:openMenu", source, {
    characterName = xPlayer.GetFull_Name(),
    favorites = favorites
})

-- Check if IBAN is in favorites
local function IsInFavorites(iban, favorites)
    for i, fav in ipairs(favorites) do
        if fav.iban == iban then
            return true
        end
    end
    return false
end
```

## Related Functions

- [ig.sql.banking.AddFavorite](ig_sql_banking_AddFavorite.md)
- [ig.sql.banking.RemoveFavorite](ig_sql_banking_RemoveFavorite.md)
- [ig.sql.char.GetByIban](ig_sql_char_GetByIban.md)

## Notes

- Returns empty table if no favorites exist or if JSON decode fails
- Uses pcall for safe JSON parsing
- Favorites are stored as JSON array in Banking_Favorites column
- Each character has their own independent favorites list

## Source

Defined in: `server/[SQL]/_banking.lua`
