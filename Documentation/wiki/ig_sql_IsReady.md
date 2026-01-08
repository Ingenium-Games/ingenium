# ig.sql.IsReady

## Description

====================================================================================--

## Signature

```lua
function ig.sql.IsReady()
```

## Parameters

- **`query`**: string SQL query to prepare
- **`queryId`**: string Query ID from PrepareQuery
- **`parameters`**: table Query parameters
- **`callback`**: function|nil Optional callback(affectedRows)

## Example

```lua
-- Example usage of ig.sql.IsReady
ig.sql.IsReady()
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
