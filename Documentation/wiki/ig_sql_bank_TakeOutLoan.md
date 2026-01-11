# ig.sql.bank.TakeOutLoan

## Description

Get - The `Bank` from the `Character_ID`

## Signature

```lua
function ig.sql.bank.TakeOutLoan(character_id, amount, duration, cb)
```

## Parameters

- **`character_id`**: any
- **`amount`**: number
- **`duration`**: number
- **`cb`**: any

## Example

```lua
-- Example usage
local result = ig.sql.bank.TakeOutLoan(value, 100, 100, value)
```

## Source

Defined in: `server/[SQL]/_bank.lua`
