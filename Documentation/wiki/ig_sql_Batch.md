# ig.sql.Batch

## Description

Execute an UPDATE or DELETE query

## Signature

```lua
function ig.sql.Batch(queries, callback)
```

## Parameters

- **`query`**: string SQL UPDATE/DELETE query
- **`parameters`**: table|nil Query parameters
- **`callback`**: function|nil Optional callback(affectedRows)
- **`queries`**: table Array of {query, parameters} objects
- **`callback`**: function|nil Optional callback(success, results)
- **`queries`**: table Array of {query, parameters} objects
- **`callback`**: function|nil Optional callback(results)

## Example

```lua
-- Example usage of ig.sql.Batch
local result = ig.sql.Batch(queries, callback)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

> 📋 **Parameter**: `callback` - Function to execute upon completion

## Related Functions

- [ig.sql.bank.AddAccount](ig_sql_bank_AddAccount.md)
- [ig.sql.bank.GetBank](ig_sql_bank_GetBank.md)
- [ig.sql.bank.GetLoan](ig_sql_bank_GetLoan.md)
- [ig.sql.bank.SetBank](ig_sql_bank_SetBank.md)
- [ig.sql.bank.SetLoan](ig_sql_bank_SetLoan.md)

## Source

Defined in: `server/[SQL]/_handler.lua`
