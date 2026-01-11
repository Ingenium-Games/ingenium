# ig.sql.char.GetCount

## Description

Get - Info on the characters owned, up to permitted slot count (not dead)

## Signature

```lua
function ig.sql.char.GetCount(primary_id, cb)
```

## Parameters

- **`primary_id`**: any
- **`cb`**: function

## Example

```lua
-- Get count data
local result = ig.sql.char.GetCount(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
