# ig.sql.veh.Add

## Description

No description available

## Signature

```lua
function ig.sql.veh.Add(data, cb)
```

## Example

```lua
-- Example usage of ig.sql.veh.Add
ig.sql.veh.Add(item)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.sql.veh.ChangeOwner](ig_sql_veh_ChangeOwner.md)
- [ig.sql.veh.GetAll](ig_sql_veh_GetAll.md)
- [ig.sql.veh.GetByPlate](ig_sql_veh_GetByPlate.md)
- [ig.sql.veh.GetID](ig_sql_veh_GetID.md)
- [ig.sql.veh.GetVehicles](ig_sql_veh_GetVehicles.md)

## Source

Defined in: `server/[SQL]/_vehicles.lua`
