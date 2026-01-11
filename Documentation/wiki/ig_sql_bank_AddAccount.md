# ig.sql.bank.AddAccount

## Description

Adds account to the system

## Signature

```lua
function ig.sql.bank.AddAccount(Character_ID, Account_Number, cb)
```

## Parameters

- **`Character_ID`**: any
- **`Account_Number`**: any
- **`cb`**: function

## Example

```lua
-- Example usage
local result = ig.sql.bank.AddAccount(value, value, function() end)
```

## Source

Defined in: `server/[SQL]/_bank.lua`
