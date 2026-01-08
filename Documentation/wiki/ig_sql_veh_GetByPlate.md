# ig.sql.veh.GetByPlate

## Description

No description available

## Signature

```lua
function ig.sql.veh.GetByPlate(Plate, cb)
```

## Example

```lua
-- Example usage of ig.sql.veh.GetByPlate
local result = ig.sql.veh.GetByPlate()
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.veh.Add](ig_sql_veh_Add.md)
- [ig.sql.veh.ChangeOwner](ig_sql_veh_ChangeOwner.md)
- [ig.sql.veh.GetAll](ig_sql_veh_GetAll.md)
- [ig.sql.veh.GetID](ig_sql_veh_GetID.md)
- [ig.sql.veh.GetVehicles](ig_sql_veh_GetVehicles.md)

## Source

Defined in: `server/[SQL]/_vehicles.lua`
