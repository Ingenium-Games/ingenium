# ig.sql.user.Find

## Description

====================================================================================--

## Signature

```lua
function ig.sql.user.Find(license_id, cb)
```

## Example

```lua
-- Example usage of ig.sql.user.Find
local result = ig.sql.user.Find(license_id, cb)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.user.Add](ig_sql_user_Add.md)
- [ig.sql.user.AddCharacterSlot](ig_sql_user_AddCharacterSlot.md)
- [ig.sql.user.Get](ig_sql_user_Get.md)
- [ig.sql.user.GetAce](ig_sql_user_GetAce.md)
- [ig.sql.user.GetBan](ig_sql_user_GetBan.md)

## Source

Defined in: `server/[SQL]/_users.lua`
