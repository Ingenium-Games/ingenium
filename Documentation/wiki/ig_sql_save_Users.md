# ig.sql.save.Users

## Description

Other Variables.

## Signature

```lua
function ig.sql.save.Users(cb)
```

## Parameters

- **`cb`**: function "To be called on SQL 'UPDATE' statements are completed.

## Example

```lua
-- Example usage of ig.sql.save.Users
local result = ig.sql.save.Users(cb)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.save.Jobs](ig_sql_save_Jobs.md)
- [ig.sql.save.Objects](ig_sql_save_Objects.md)
- [ig.sql.save.User](ig_sql_save_User.md)
- [ig.sql.save.Vehicle](ig_sql_save_Vehicle.md)
- [ig.sql.save.Vehicles](ig_sql_save_Vehicles.md)

## Source

Defined in: `server/[SQL]/_saves.lua`
