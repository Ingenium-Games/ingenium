# ig.sql.char.GetOutfitByNumber

## Description

Retrieves and returns outfitbynumber data

## Signature

```lua
function ig.sql.char.GetOutfitByNumber(character_id, number, cb)
```

## Parameters

- **`character_id`**: any
- **`number`**: any
- **`cb`**: function

## Example

```lua
-- Get outfitbynumber data
local result = ig.sql.char.GetOutfitByNumber(value, value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
