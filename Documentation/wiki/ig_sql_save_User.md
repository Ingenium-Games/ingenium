# ig.sql.save.User

## Description

[[ Players ]] --

## Signature

```lua
function ig.sql.save.User(data, cb)
```

## Parameters

- **`saveFunc`**: function "The save function to execute
- **`cb`**: function "Callback to execute after save
- **`data`**: table "xPlayer table
- **`cb`**: function "To be called on SQL 'UPDATE' statement completion.

## Example

```lua
-- Example usage of ig.sql.save.User
local result = ig.sql.save.User(data, cb)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.sql.save.Jobs](ig_sql_save_Jobs.md)
- [ig.sql.save.Objects](ig_sql_save_Objects.md)
- [ig.sql.save.Users](ig_sql_save_Users.md)
- [ig.sql.save.Vehicle](ig_sql_save_Vehicle.md)
- [ig.sql.save.Vehicles](ig_sql_save_Vehicles.md)

## Source

Defined in: `server/[SQL]/_saves.lua`
