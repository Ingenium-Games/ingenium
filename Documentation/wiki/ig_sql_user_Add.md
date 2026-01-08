# ig.sql.user.Add

## Description

====================================================================================--

## Signature

```lua
function ig.sql.user.Add(usermame, license_id, fivem_id, steam_id, discord_id, ip, cb)
```

## Example

```lua
-- Example usage of ig.sql.user.Add
ig.sql.user.Add(item)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.user.AddCharacterSlot](ig_sql_user_AddCharacterSlot.md)
- [ig.sql.user.Find](ig_sql_user_Find.md)
- [ig.sql.user.Get](ig_sql_user_Get.md)
- [ig.sql.user.GetAce](ig_sql_user_GetAce.md)
- [ig.sql.user.GetBan](ig_sql_user_GetBan.md)

## Source

Defined in: `server/[SQL]/_users.lua`
