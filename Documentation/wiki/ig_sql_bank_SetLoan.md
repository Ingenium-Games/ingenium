# ig.sql.bank.SetLoan

## Description

Get - The `Loan` from the `Character_ID`

## Signature

```lua
function ig.sql.bank.SetLoan(character_id, loan, duration, cb)
```

## Parameters

- **`character_id`**: any
- **`loan`**: any
- **`duration`**: any
- **`cb`**: function

## Example

```lua
-- Set loan
ig.sql.bank.SetLoan(value, value, value, function() end)
```

## Source

Defined in: `server/[SQL]/_bank.lua`
