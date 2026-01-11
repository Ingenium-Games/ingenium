# ig.sql.char.GetAllPermited

## Description

Get - Info on the characters owned to prefill the multicharacter selection

## Signature

```lua
function ig.sql.char.GetAllPermited(primary_id, slots, cb)
```

## Parameters

- **`primary_id`**: any
- **`slots`**: any
- **`cb`**: function

## Example

```lua
-- Get allpermited data
local result = ig.sql.char.GetAllPermited(value, value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
