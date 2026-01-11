# ig.sql.char.GetAll

## Description

Retrieves and returns all data

## Signature

```lua
function ig.sql.char.GetAll(primary_id, cb)
```

## Parameters

- **`primary_id`**: any
- **`cb`**: function

## Example

```lua
-- Get all data
local result = ig.sql.char.GetAll(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
