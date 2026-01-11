# ig.sql.bank.GetBank

## Description

Retrieves and returns bank data

## Signature

```lua
function ig.sql.bank.GetBank(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get bank data
local result = ig.sql.bank.GetBank(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_bank.lua`
