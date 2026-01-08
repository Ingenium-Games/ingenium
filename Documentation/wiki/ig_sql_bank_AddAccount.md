# ig.sql.bank.AddAccount

## Description

====================================================================================--

## Signature

```lua
function ig.sql.bank.AddAccount(Character_ID, Account_Number, cb)
```

## Example

```lua
-- Example usage of ig.sql.bank.AddAccount
ig.sql.bank.AddAccount(item)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

> ⚠️ **Security**: This function accesses player identifiers or can ban/kick players. Ensure proper permission checks.

## Related Functions

- [ig.sql.bank.GetBank](ig_sql_bank_GetBank.md)
- [ig.sql.bank.GetLoan](ig_sql_bank_GetLoan.md)
- [ig.sql.bank.SetBank](ig_sql_bank_SetBank.md)
- [ig.sql.bank.SetLoan](ig_sql_bank_SetLoan.md)
- [ig.sql.bank.TakeOutLoan](ig_sql_bank_TakeOutLoan.md)

## Source

Defined in: `server/[SQL]/_bank.lua`
