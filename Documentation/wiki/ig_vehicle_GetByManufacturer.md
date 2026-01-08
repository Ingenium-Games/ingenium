# ig.vehicle.GetByManufacturer

## Description

Get vehicle data by name

## Signature

```lua
function ig.vehicle.GetByManufacturer(manufacturer)
```

## Parameters

- **`name`**: string Vehicle model name
- **`class`**: string Vehicle class (e.g., "Sports", "Super", "SUV")
- **`manufacturer`**: string Manufacturer name

## Example

```lua
-- Example usage of ig.vehicle.GetByManufacturer
local result = ig.vehicle.GetByManufacturer()
```

## Related Functions

- [ig.vehicle.ClearCache](ig_vehicle_ClearCache.md)
- [ig.vehicle.GetAll](ig_vehicle_GetAll.md)
- [ig.vehicle.GetByHash](ig_vehicle_GetByHash.md)
- [ig.vehicle.GetDisplayName](ig_vehicle_GetDisplayName.md)
- [ig.vehicle.GetCurrentSeat](ig_vehicle_GetCurrentSeat.md)

## Source

Defined in: `server/[Data - No Save Needed]/_vehicle.lua`
