# ig.sql.char.GetAllWanted

## Description

SET - The `Is_Dead` = BOOLEAN for the `Character_ID`

## Signature

```lua
function ig.sql.char.GetAllWanted(cb)
```

## Parameters

- **`cb`**: function

## Example

```lua
-- Get allwanted data
local result = ig.sql.char.GetAllWanted(function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
