# ig.sql.GetStats

## Description

====================================================================================--

## Signature

```lua
function ig.sql.GetStats()
```

## Parameters

- **`timeout`**: number|nil Timeout in milliseconds (default 30000)

## Example

```lua
-- Example usage of ig.sql.GetStats
local result = ig.sql.GetStats()
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
