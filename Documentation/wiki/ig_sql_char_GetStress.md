# ig.sql.char.GetStress

## Description

Get - The `Hunger` by Character_ID

## Signature

```lua
function ig.sql.char.GetStress(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get stress data
local result = ig.sql.char.GetStress(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
