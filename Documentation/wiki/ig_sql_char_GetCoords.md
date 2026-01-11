# ig.sql.char.GetCoords

## Description

Get - The `Character_ID` by phone number

## Signature

```lua
function ig.sql.char.GetCoords(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get coords data
local result = ig.sql.char.GetCoords(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
