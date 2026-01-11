# ig.sql.char.GetOutfitsAsCount

## Description

Retrieves and returns outfitsascount data

## Signature

```lua
function ig.sql.char.GetOutfitsAsCount(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get outfitsascount data
local result = ig.sql.char.GetOutfitsAsCount(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
