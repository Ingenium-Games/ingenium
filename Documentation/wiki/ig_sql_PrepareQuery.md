# ig.sql.PrepareQuery

## Description

Execute multiple queries in a transaction

## Signature

```lua
function ig.sql.PrepareQuery(query)
```

## Parameters

- **`queries`**: table Array of {query, parameters} objects
- **`callback`**: function|nil Optional callback(success, results)
- **`queries`**: table Array of {query, parameters} objects
- **`callback`**: function|nil Optional callback(results)
- **`query`**: string SQL query to prepare

## Example

```lua
-- Example usage of ig.sql.PrepareQuery
local result = ig.sql.PrepareQuery(query)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

## Related Functions

- [ig.sql.bank.AddAccount](ig_sql_bank_AddAccount.md)
- [ig.sql.bank.GetBank](ig_sql_bank_GetBank.md)
- [ig.sql.bank.GetLoan](ig_sql_bank_GetLoan.md)
- [ig.sql.bank.SetBank](ig_sql_bank_SetBank.md)
- [ig.sql.bank.SetLoan](ig_sql_bank_SetLoan.md)

## Source

Defined in: `server/[SQL]/_handler.lua`
