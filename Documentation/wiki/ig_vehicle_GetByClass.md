# ig.vehicle.GetByClass

## Description

Get all vehicle data

## Signature

```lua
function ig.vehicle.GetByClass(class)
```

## Parameters

- **`hash`**: number Vehicle hash
- **`name`**: string Vehicle model name
- **`class`**: string Vehicle class (e.g., "Sports", "Super", "SUV")

## Example

```lua
-- Example usage of ig.vehicle.GetByClass
local result = ig.vehicle.GetByClass()
```

## Related Functions

- [ig.vehicle.ClearCache](ig_vehicle_ClearCache.md)
- [ig.vehicle.GetAll](ig_vehicle_GetAll.md)
- [ig.vehicle.GetByHash](ig_vehicle_GetByHash.md)
- [ig.vehicle.GetDisplayName](ig_vehicle_GetDisplayName.md)
- [ig.vehicle.GetCurrentSeat](ig_vehicle_GetCurrentSeat.md)

## Source

Defined in: `server/[Data - No Save Needed]/_vehicle.lua`
