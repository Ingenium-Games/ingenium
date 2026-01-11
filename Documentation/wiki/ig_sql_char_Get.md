# ig.sql.char.Get

## Description

Get - Info on the characters owned to prefill the multicharacter selection (not dead)

## Signature

```lua
function ig.sql.char.Get(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get  data
local result = ig.sql.char.Get(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
