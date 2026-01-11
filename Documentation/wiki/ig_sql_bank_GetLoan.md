# ig.sql.bank.GetLoan

## Description

SET - The `Bank` from the `Character_ID`

## Signature

```lua
function ig.sql.bank.GetLoan(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get loan data
local result = ig.sql.bank.GetLoan(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_bank.lua`
