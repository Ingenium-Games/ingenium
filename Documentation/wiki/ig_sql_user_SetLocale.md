# ig.sql.user.SetLocale

## Description

Get - `Locale` from the users License_ID

## Signature

```lua
function ig.sql.user.SetLocale(locale, license_id, cb)
```

## Example

```lua
-- Example usage of ig.sql.user.SetLocale
ig.sql.user.SetLocale(value)
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
