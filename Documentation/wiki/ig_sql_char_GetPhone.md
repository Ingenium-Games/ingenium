# ig.sql.char.GetPhone

## Description

Get ALL - The `Wanted` Boolean TRUE from the characters table

## Signature

```lua
function ig.sql.char.GetPhone(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get phone data
local result = ig.sql.char.GetPhone(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
