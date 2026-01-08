# ig.sql.ResetActiveCharacters

## Description

SET - The `Active` = BOOLEAN for the `Character_ID`

## Signature

```lua
function ig.sql.ResetActiveCharacters(cb)
```

## Example

```lua
-- Example usage of ig.sql.ResetActiveCharacters
local result = ig.sql.ResetActiveCharacters(cb)
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

Defined in: `server/[SQL]/_character.lua`
