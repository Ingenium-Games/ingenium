# ig.sql.veh.GetVehicles

## Description

Retrieves and returns vehicles data

## Signature

```lua
function ig.sql.veh.GetVehicles(cb)
```

## Parameters

- **`cb`**: function

## Example

```lua
-- Get vehicles data
local result = ig.sql.veh.GetVehicles(function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_vehicles.lua`
