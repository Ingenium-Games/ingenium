# ig.sql.user.GetAce

## Description

Get - `Locale` from the users License_ID

## Signature

```lua
function ig.sql.user.GetAce(license_id, cb)
```

## Example

```lua
-- Example usage of ig.sql.user.GetAce
local result = ig.sql.user.GetAce()
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.user.Add](ig_sql_user_Add.md)
- [ig.sql.user.AddCharacterSlot](ig_sql_user_AddCharacterSlot.md)
- [ig.sql.user.Find](ig_sql_user_Find.md)
- [ig.sql.user.Get](ig_sql_user_Get.md)
- [ig.sql.user.GetBan](ig_sql_user_GetBan.md)

## Source

Defined in: `server/[SQL]/_users.lua`
