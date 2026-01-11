# ig.sql.veh.GetByPlate

## Description

Retrieves and returns byplate data

## Signature

```lua
function ig.sql.veh.GetByPlate(Plate, cb)
```

## Parameters

- **`Plate`**: any
- **`cb`**: function

## Example

```lua
-- Get byplate data
local result = ig.sql.veh.GetByPlate(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_vehicles.lua`
