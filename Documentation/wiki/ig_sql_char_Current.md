# ig.sql.char.Current

## Description

Get - The entire ROW of data from Characters table where the Character_ID is the character id.

## Signature

```lua
function ig.sql.char.Current(primary_id, cb)
```

## Example

```lua
-- Example usage of ig.sql.char.Current
local result = ig.sql.char.Current(primary_id, cb)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.char.Add](ig_sql_char_Add.md)
- [ig.sql.char.AddOutfit](ig_sql_char_AddOutfit.md)
- [ig.sql.char.Delete](ig_sql_char_Delete.md)
- [ig.sql.char.Get](ig_sql_char_Get.md)
- [ig.sql.char.GetAll](ig_sql_char_GetAll.md)

## Source

Defined in: `server/[SQL]/_character.lua`
