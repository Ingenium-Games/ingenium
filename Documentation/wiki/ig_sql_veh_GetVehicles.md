# ig.sql.veh.GetVehicles

## Description

====================================================================================--

## Signature

```lua
function ig.sql.veh.GetVehicles(cb)
```

## Parameters

- **`cb`**: function "Callback function if any, called after the SQL statement.

## Example

```lua
-- Example usage of ig.sql.veh.GetVehicles
local result = ig.sql.veh.GetVehicles()
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.veh.Add](ig_sql_veh_Add.md)
- [ig.sql.veh.ChangeOwner](ig_sql_veh_ChangeOwner.md)
- [ig.sql.veh.GetAll](ig_sql_veh_GetAll.md)
- [ig.sql.veh.GetByPlate](ig_sql_veh_GetByPlate.md)
- [ig.sql.veh.GetID](ig_sql_veh_GetID.md)

## Source

Defined in: `server/[SQL]/_vehicles.lua`
