# ig.sql.char.GetAppearance

## Description

Retrieves and returns appearance data

## Signature

```lua
function ig.sql.char.GetAppearance(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Get appearance data
local result = ig.sql.char.GetAppearance(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
