# ig.sql.banking.RemoveFavorite

## Description

Removes a favorite payee from a character's saved favorites list.

## Signature

```lua
function ig.sql.banking.RemoveFavorite(characterId, iban)
```

## Parameters

- **`characterId`**: string - The Character_ID to remove the favorite from
- **`iban`**: string - The IBAN of the favorite to remove

## Returns

- **`boolean`**: `true` if favorite was removed, `false` if not found

## Example

```lua
-- Remove a favorite
local xPlayer = ig.data.GetPlayer(source)
local success = ig.sql.banking.RemoveFavorite(xPlayer.GetCharacter_ID(), "123456789")

if success then
    xPlayer.Notify("Favorite removed successfully", "green", 3000)
else
    xPlayer.Notify("Favorite not found", "red", 3000)
end

-- Remove all favorites for a character
local function ClearAllFavorites(characterId)
    local favorites = ig.sql.banking.GetFavorites(characterId)
    
    for i, favorite in ipairs(favorites) do
        ig.sql.banking.RemoveFavorite(characterId, favorite.iban)
    end
    
    print("Cleared " .. #favorites .. " favorites")
end
```

## Related Functions

- [ig.sql.banking.GetFavorites](ig_sql_banking_GetFavorites.md)
- [ig.sql.banking.AddFavorite](ig_sql_banking_AddFavorite.md)

## Notes

- Updates the Banking_Favorites JSON array in the database
- Returns false if the IBAN is not in the favorites list
- Safe to call even if the favorite doesn't exist

## Source

Defined in: `server/[SQL]/_banking.lua`
