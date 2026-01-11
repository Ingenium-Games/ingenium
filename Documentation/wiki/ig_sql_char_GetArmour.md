# ig.sql.char.GetArmour

## Description

Retrieves and returns armour data

## Signature

```lua
function ig.sql.char.GetArmour(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get armour data
local result = ig.sql.char.GetArmour(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
