# ig.vehicle.GetVehicle

## Description

local aa, bb, cc = ig.vehicle.FindVehicle(net)

## Signature

```lua
function ig.vehicle.GetVehicle(arg)
```

## Parameters

- **`arg`**: number

## Example

```lua
-- Get vehicle data
local result = ig.vehicle.GetVehicle(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_vehicles.lua`
