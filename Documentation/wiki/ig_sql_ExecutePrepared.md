# ig.sql.ExecutePrepared

## Description

Execute multiple queries as a batch (without transaction)

## Signature

```lua
function ig.sql.ExecutePrepared(queryId, parameters, callback)
```

## Parameters

- **`queries`**: table Array of {query, parameters} objects
- **`callback`**: function|nil Optional callback(results)
- **`query`**: string SQL query to prepare
- **`queryId`**: string Query ID from PrepareQuery
- **`parameters`**: table Query parameters
- **`callback`**: function|nil Optional callback(affectedRows)

## Example

```lua
-- Example usage of ig.sql.ExecutePrepared
local result = ig.sql.ExecutePrepared(queryId, parameters, callback)
```

## Important Notes

> ⚠️ **Security**: This function executes code dynamically. Never use with untrusted input.

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
