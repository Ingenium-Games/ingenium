# ig.vehicle.SetVehicle

## Description

local aa, bb, cc = ig.vehicle.FindVehicle(net)

## Signature

```lua
function ig.vehicle.SetVehicle(net, cb, ...)
```

## Parameters

- **`net`**: number
- **`cb`**: function
- **`...`**: any

## Example

```lua
-- Set vehicle
ig.vehicle.SetVehicle(100, function() end, value)
```

## Source

Defined in: `server/[Objects]/_vehicles.lua`
