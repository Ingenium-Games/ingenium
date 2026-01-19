# ig.vehicle.GetByHash

## Description

Retrieves vehicle data for a specific vehicle model hash. Each vehicle in the game has a unique hash that identifies it. This function looks up and returns the complete vehicle data including name, label, class, manufacturer, and other properties.

## Signature

```lua
function ig.vehicle.GetByHash(hash)
```

## Parameters

- **`hash`**: number - The vehicle model hash to look up

## Returns

- **`table|nil`** - Vehicle data table if found, nil otherwise

## Example

```lua
-- Get vehicle data by hash
local vehicleHash = GetHashKey("adder")
local vehicle = ig.vehicle.GetByHash(vehicleHash)

if vehicle then
    print("Vehicle Name:", vehicle.name)
    print("Display Name:", vehicle.label)
    print("Class:", vehicle.class)
    print("Manufacturer:", vehicle.manufacturer)
else
    print("Vehicle not found")
end

-- Check if vehicle exists before using
local hash = GetHashKey("t20")
local vehicleData = ig.vehicle.GetByHash(hash)
if vehicleData then
    print(string.format("Found: %s", vehicleData.label))
end
```

## Related Functions

- [ig.vehicle.GetAll](ig_vehicle_GetAll.md) - Get all vehicles
- [ig.vehicle.GetByName](ig_vehicle_GetByName.md) - Get vehicle by model name
- [ig.vehicle.GetDisplayName](ig_vehicle_GetDisplayName.md) - Get vehicle display name
- [ig.vehicle.IsAircraft](ig_vehicle_IsAircraft.md) - Check if vehicle is aircraft
- [ig.vehicle.IsBoa](ig_vehicle_IsBoa.md) - Check if vehicle is boat

## Source

Defined in: `server/[Data - No Save Needed]/_vehicle.lua`
