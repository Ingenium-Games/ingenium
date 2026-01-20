# ig.data.GetVehicles

## Description

Retrieves all vehicle entities in the server.

## Signature

```lua
function ig.data.GetVehicles()
```

## Parameters

None

## Returns

- **`table`** - The complete `ig.vdex` table containing all vehicle entities indexed by network ID

## Example

```lua
-- Get all vehicles and count them
local vehicles = ig.data.GetVehicles()
local count = 0
for netId, vehicle in pairs(vehicles) do
    count = count + 1
    print("Vehicle plate:", vehicle.GetPlate())
end
print("Total vehicles:", count)
```

## Source

Defined in: `server/_data.lua` (delegates to `ig.vehicle.GetVehicles` in `server/[Objects]/_vehicles.lua`)
