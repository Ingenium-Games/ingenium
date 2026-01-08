# ig.sql.char.SetInstance

## Description

Get - The `Active` = TRUE `Character_ID` from the Primary_ID identifier

## Signature

```lua
function ig.sql.char.SetInstance(character_id, instance_id, cb)
```

## Example

```lua
-- Example usage of ig.sql.char.SetInstance
ig.sql.char.SetInstance(value)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.char.Add](ig_sql_char_Add.md)
- [ig.sql.char.AddOutfit](ig_sql_char_AddOutfit.md)
- [ig.sql.char.Current](ig_sql_char_Current.md)
- [ig.sql.char.Delete](ig_sql_char_Delete.md)
- [ig.sql.char.Get](ig_sql_char_Get.md)

## Source

Defined in: `server/[SQL]/_character.lua`
