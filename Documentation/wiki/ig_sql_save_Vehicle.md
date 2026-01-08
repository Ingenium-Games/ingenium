# ig.sql.save.Vehicle

## Description

Where Conditions

## Signature

```lua
function ig.sql.save.Vehicle(data, cb)
```

## Parameters

- **`data`**: table "xCar table
- **`cb`**: function "To be called on SQL 'UPDATE' statement completion.

## Example

```lua
-- Example usage of ig.sql.save.Vehicle
local result = ig.sql.save.Vehicle(data, cb)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.sql.save.Jobs](ig_sql_save_Jobs.md)
- [ig.sql.save.Objects](ig_sql_save_Objects.md)
- [ig.sql.save.User](ig_sql_save_User.md)
- [ig.sql.save.Users](ig_sql_save_Users.md)
- [ig.sql.save.Vehicles](ig_sql_save_Vehicles.md)

## Source

Defined in: `server/[SQL]/_saves.lua`
