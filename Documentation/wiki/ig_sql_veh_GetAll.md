# ig.sql.veh.GetAll

## Description

Retrieves and returns all data

## Signature

```lua
function ig.sql.veh.GetAll(Character_ID, cb)
```

## Parameters

- **`Character_ID`**: any
- **`cb`**: function

## Example

```lua
-- Get all data
local result = ig.sql.veh.GetAll(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_vehicles.lua`
