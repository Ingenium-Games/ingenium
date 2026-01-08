# ig.sql.user.Update

## Description

====================================================================================--

## Signature

```lua
function ig.sql.user.Update(usermame, license_id, fivem_id, steam_id, discord_id, ip, cb)
```

## Example

```lua
-- Example usage of ig.sql.user.Update
local result = ig.sql.user.Update(usermame, license_id, fivem_id, steam_id, discord_id, ip, cb)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.user.Add](ig_sql_user_Add.md)
- [ig.sql.user.AddCharacterSlot](ig_sql_user_AddCharacterSlot.md)
- [ig.sql.user.Find](ig_sql_user_Find.md)
- [ig.sql.user.Get](ig_sql_user_Get.md)
- [ig.sql.user.GetAce](ig_sql_user_GetAce.md)

## Source

Defined in: `server/[SQL]/_users.lua`
