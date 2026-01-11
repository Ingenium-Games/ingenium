# ig.sql.char.GetCityId

## Description

Retrieves and returns cityid data

## Signature

```lua
function ig.sql.char.GetCityId(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get cityid data
local result = ig.sql.char.GetCityId(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
