# ig.sql.char.AddOutfit

## Description

SET - The `Coords` for Character_ID

## Signature

```lua
function ig.sql.char.AddOutfit(character_id, number, style, cb)
```

## Example

```lua
-- Example usage of ig.sql.char.AddOutfit
ig.sql.char.AddOutfit(item)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.char.Add](ig_sql_char_Add.md)
- [ig.sql.char.Current](ig_sql_char_Current.md)
- [ig.sql.char.Delete](ig_sql_char_Delete.md)
- [ig.sql.char.Get](ig_sql_char_Get.md)
- [ig.sql.char.GetAll](ig_sql_char_GetAll.md)

## Source

Defined in: `server/[SQL]/_character.lua`
