# ig.sql.FetchScalar

## Description

Execute a SELECT query that returns a single row

## Signature

```lua
function ig.sql.FetchScalar(query, parameters, callback)
```

## Parameters

- **`query`**: string SQL query
- **`parameters`**: table|nil Query parameters
- **`callback`**: function|nil Optional callback(result)
- **`query`**: string SQL query
- **`parameters`**: table|nil Query parameters
- **`callback`**: function|nil Optional callback(value)

## Example

```lua
-- Example usage of ig.sql.FetchScalar
local result = ig.sql.FetchScalar(query, parameters, callback)
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
