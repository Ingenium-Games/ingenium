# ig.sql.Insert

## Description

Execute a SELECT query that returns a single value

## Signature

```lua
function ig.sql.Insert(query, parameters, callback)
```

## Parameters

- **`query`**: string SQL query
- **`parameters`**: table|nil Query parameters
- **`callback`**: function|nil Optional callback(value)
- **`query`**: string SQL INSERT query
- **`parameters`**: table|nil Query parameters
- **`callback`**: function|nil Optional callback(insertId)

## Example

```lua
-- Example usage of ig.sql.Insert
local result = ig.sql.Insert(query, parameters, callback)
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
