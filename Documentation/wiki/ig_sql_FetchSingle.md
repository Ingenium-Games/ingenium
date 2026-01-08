# ig.sql.FetchSingle

## Description

====================================================================================--

## Signature

```lua
function ig.sql.FetchSingle(query, parameters, callback)
```

## Parameters

- **`query`**: string SQL query with ? placeholders or @named parameters
- **`parameters`**: table|nil Query parameters (array for ? or table for @named)
- **`callback`**: function|nil Optional callback(results)
- **`query`**: string SQL query
- **`parameters`**: table|nil Query parameters
- **`callback`**: function|nil Optional callback(result)

## Example

```lua
-- Example usage of ig.sql.FetchSingle
local result = ig.sql.FetchSingle(query, parameters, callback)
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
