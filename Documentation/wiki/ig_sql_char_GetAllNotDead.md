# ig.sql.char.GetAllNotDead

## Description

Get - Info on the characters owned to prefill the multicharacter selection

## Signature

```lua
function ig.sql.char.GetAllNotDead(primary_id, cb)
```

## Parameters

- **`primary_id`**: any
- **`cb`**: function

## Example

```lua
-- Get allnotdead data
local result = ig.sql.char.GetAllNotDead(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
