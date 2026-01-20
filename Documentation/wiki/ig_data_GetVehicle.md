# ig.data.GetVehicle

## Description

Retrieves a vehicle entity by its network ID.

## Signature

```lua
function ig.data.GetVehicle(net)
```

## Parameters

- **`net`**: number - The network ID of the vehicle

## Returns

- **`table|false`** - The vehicle entity table if found, `false` otherwise

## Example

```lua
-- Get a vehicle by network ID
local vehicle = ig.data.GetVehicle(netId)
if vehicle then
    print("Vehicle plate:", vehicle.GetPlate())
end
```

## Source

Defined in: `server/_data.lua` (delegates to `ig.vehicle.GetVehicle` in `server/[Objects]/_vehicles.lua`)
