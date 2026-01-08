# ig.sql.Transaction

## Description

Execute an UPDATE or DELETE query

## Signature

```lua
function ig.sql.Transaction(queries, callback)
```

## Parameters

- **`query`**: string SQL UPDATE/DELETE query
- **`parameters`**: table|nil Query parameters
- **`callback`**: function|nil Optional callback(affectedRows)
- **`queries`**: table Array of {query, parameters} objects
- **`callback`**: function|nil Optional callback(success, results)

## Example

```lua
-- Example usage of ig.sql.Transaction
local result = ig.sql.Transaction(queries, callback)
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
