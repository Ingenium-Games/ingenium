# ig.sql.banking.AddFavorite

## Description

Adds a new favorite payee to a character's saved favorites list.

## Signature

```lua
function ig.sql.banking.AddFavorite(characterId, favorite)
```

## Parameters

- **`characterId`**: string - The Character_ID to add the favorite for
- **`favorite`**: table - Favorite data containing:
  - `iban`: string - The recipient's IBAN
  - `name`: string - Friendly name for the recipient

## Returns

- **`boolean`**: `true` if favorite was added, `false` if it already exists

## Example

```lua
-- Add a favorite after a successful transfer
local xPlayer = ig.data.GetPlayer(source)
local success = ig.sql.banking.AddFavorite(xPlayer.GetCharacter_ID(), {
    iban = "123456789",
    name = "John Doe"
})

if success then
    xPlayer.Notify("Favorite added successfully", "green", 3000)
else
    xPlayer.Notify("This contact is already in your favorites", "orange", 3000)
end

-- Validate and add favorite
local function SaveFavorite(source, iban, name)
    local xPlayer = ig.data.GetPlayer(source)
    
    -- Verify IBAN exists
    local targetCharacter = ig.sql.char.GetByIban(iban)
    if not targetCharacter then
        return false, "Invalid IBAN"
    end
    
    -- Add to favorites
    local success = ig.sql.banking.AddFavorite(xPlayer.GetCharacter_ID(), {
        iban = iban,
        name = name
    })
    
    return success
end
```

## Related Functions

- [ig.sql.banking.GetFavorites](ig_sql_banking_GetFavorites.md)
- [ig.sql.banking.RemoveFavorite](ig_sql_banking_RemoveFavorite.md)
- [ig.sql.char.GetByIban](ig_sql_char_GetByIban.md)

## Notes

- Checks for duplicates before adding
- Updates the Banking_Favorites JSON array in the database
- Favorites persist across sessions
- Each character can have unlimited favorites (within JSON limits)

## Source

Defined in: `server/[SQL]/_banking.lua`
