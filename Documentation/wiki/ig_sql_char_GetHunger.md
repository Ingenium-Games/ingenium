# ig.sql.char.GetHunger

## Description

Get - The `Health` by Character_ID

## Signature

```lua
function ig.sql.char.GetHunger(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get hunger data
local result = ig.sql.char.GetHunger(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
