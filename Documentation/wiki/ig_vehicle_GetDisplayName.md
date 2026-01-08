# ig.vehicle.GetDisplayName

## Description

Get vehicles by class

## Signature

```lua
function ig.vehicle.GetDisplayName(hash)
```

## Parameters

- **`class`**: string Vehicle class (e.g., "Sports", "Super", "SUV")
- **`manufacturer`**: string Manufacturer name
- **`hash`**: number Vehicle hash

## Example

```lua
-- Example usage of ig.vehicle.GetDisplayName
local result = ig.vehicle.GetDisplayName()
```

## Related Functions

- [ig.vehicle.ClearCache](ig_vehicle_ClearCache.md)
- [ig.vehicle.GetAll](ig_vehicle_GetAll.md)
- [ig.vehicle.GetByHash](ig_vehicle_GetByHash.md)
- [ig.vehicle.GetCurrentSeat](ig_vehicle_GetCurrentSeat.md)
- [ig.vehicle.GetCurrentVehicle](ig_vehicle_GetCurrentVehicle.md)

## Source

Defined in: `server/[Data - No Save Needed]/_vehicle.lua`
