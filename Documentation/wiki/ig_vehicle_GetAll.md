# ig.vehicle.GetAll

## Description

Returns all vehicle data from the server's vehicle registry. This includes all available vehicle models with their properties such as hash, name, label, class, manufacturer, and other metadata. Returns the original unprotected data for network transmission.

## Signature

```lua
function ig.vehicle.GetAll()
```

## Parameters

None

## Returns

- **`table`** - Table containing all vehicles data indexed by vehicle hash

## Example

```lua
-- Get all vehicles
local vehicles = ig.vehicle.GetAll()
for hash, vehicle in pairs(vehicles) do
    print(string.format("%s - %s (%s)", vehicle.name, vehicle.label, vehicle.class))
end

-- Count vehicles by class
local classCounts = {}
for _, vehicle in pairs(vehicles) do
    classCounts[vehicle.class] = (classCounts[vehicle.class] or 0) + 1
end
```

## Related Functions

- [ig.vehicle.GetByHash](ig_vehicle_GetByHash.md) - Get specific vehicle by hash
- [ig.vehicle.GetByName](ig_vehicle_GetByName.md) - Get vehicle by model name
- [ig.vehicle.GetByClass](ig_vehicle_GetByClass.md) - Get vehicles by class
- [ig.vehicle.GetByManufacturer](ig_vehicle_GetByManufacturer.md) - Get vehicles by manufacturer
- [ig.vehicle.GetDisplayName](ig_vehicle_GetDisplayName.md) - Get vehicle display name

## Source

Defined in: `server/[Data - No Save Needed]/_vehicle.lua`
