# ig.sql.char.GetHealth

## Description

Get count of character outfits by Character_ID

## Signature

```lua
function ig.sql.char.GetHealth(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get health data
local result = ig.sql.char.GetHealth(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
