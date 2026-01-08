# ig.sql.char.GetFromCityId

## Description

Get - The `Character_ID` by phone number

## Signature

```lua
function ig.sql.char.GetFromCityId(city_id, cb)
```

## Example

```lua
-- Example usage of ig.sql.char.GetFromCityId
local result = ig.sql.char.GetFromCityId()
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
