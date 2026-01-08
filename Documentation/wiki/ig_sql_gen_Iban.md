# ig.sql.gen.Iban

## Description

No description available

## Signature

```lua
function ig.sql.gen.Iban(cb)
```

## Example

```lua
-- Example usage of ig.sql.gen.Iban
local result = ig.sql.gen.Iban(cb)
```

## Important Notes

> ⚠️ **Security**: This function interacts with the database. Always validate and sanitize inputs to prevent SQL injection.

> ⚠️ **Security**: This function accesses player identifiers or can ban/kick players. Ensure proper permission checks.

## Related Functions

- [ig.sql.gen.AccountNumber](ig_sql_gen_AccountNumber.md)
- [ig.sql.gen.CarPlate](ig_sql_gen_CarPlate.md)
- [ig.sql.gen.CharacterID](ig_sql_gen_CharacterID.md)
- [ig.sql.gen.CityID](ig_sql_gen_CityID.md)
- [ig.sql.gen.PhoneNumber](ig_sql_gen_PhoneNumber.md)

## Source

Defined in: `server/[SQL]/_gen.lua`
