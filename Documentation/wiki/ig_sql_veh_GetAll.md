# ig.sql.veh.GetAll

## Description

====================================================================================--

## Signature

```lua
function ig.sql.veh.GetAll(Character_ID, cb)
```

## Parameters

- **`cb`**: function "Callback function if any, called after the SQL statement.

## Example

```lua
-- Example usage of ig.sql.veh.GetAll
local result = ig.sql.veh.GetAll()
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.veh.Add](ig_sql_veh_Add.md)
- [ig.sql.veh.ChangeOwner](ig_sql_veh_ChangeOwner.md)
- [ig.sql.veh.GetByPlate](ig_sql_veh_GetByPlate.md)
- [ig.sql.veh.GetID](ig_sql_veh_GetID.md)
- [ig.sql.veh.GetVehicles](ig_sql_veh_GetVehicles.md)

## Source

Defined in: `server/[SQL]/_vehicles.lua`
