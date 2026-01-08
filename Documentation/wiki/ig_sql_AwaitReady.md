# ig.sql.AwaitReady

## Description

Prepare a query for later execution (returns query ID)

## Signature

```lua
function ig.sql.AwaitReady(timeout)
```

## Parameters

- **`query`**: string SQL query to prepare
- **`queryId`**: string Query ID from PrepareQuery
- **`parameters`**: table Query parameters
- **`callback`**: function|nil Optional callback(affectedRows)
- **`timeout`**: number|nil Timeout in milliseconds (default 30000)

## Example

```lua
-- Example usage of ig.sql.AwaitReady
local result = ig.sql.AwaitReady("eventName", arg1, arg2)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

> 📋 **Parameter**: `timeout` - Sets maximum wait time for operation

## Related Functions

- [ig.sql.bank.AddAccount](ig_sql_bank_AddAccount.md)
- [ig.sql.bank.GetBank](ig_sql_bank_GetBank.md)
- [ig.sql.bank.GetLoan](ig_sql_bank_GetLoan.md)
- [ig.sql.bank.SetBank](ig_sql_bank_SetBank.md)
- [ig.sql.bank.SetLoan](ig_sql_bank_SetLoan.md)

## Source

Defined in: `server/[SQL]/_handler.lua`
