# ig.sql.char.GetThirst

## Description

Get - The `Armour` by Character_ID

## Signature

```lua
function ig.sql.char.GetThirst(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get thirst data
local result = ig.sql.char.GetThirst(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
