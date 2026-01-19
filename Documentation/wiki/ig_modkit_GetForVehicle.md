# ig.modkit.GetForVehicle

## Description

Retrieves the modkit configuration for a specific vehicle hash. Searches through all modkits to find the one matching the given vehicle hash. Returns nil if no modkit exists for the vehicle.

## Signature

```lua
function ig.modkit.GetForVehicle(vehicleHash)
```

## Parameters

- **`vehicleHash`**: number - The vehicle model hash to search for

## Returns

- **`table|nil`** - Modkit data table if found, nil otherwise

## Example

```lua
-- Get modkit for a specific vehicle
local vehicleHash = GetHashKey("adder")
local modkit = ig.modkit.GetForVehicle(vehicleHash)

if modkit then
    print("Found modkit ID:", modkit.id)
    print("Available mods:", json.encode(modkit))
else
    print("No modkit available for this vehicle")
end
```

## Related Functions

- [ig.modkit.GetAll](ig_modkit_GetAll.md) - Get all modkits
- [ig.modkit.GetByID](ig_modkit_GetByID.md) - Get specific modkit by ID
- [ig.modkit.HasModkit](ig_modkit_HasModkit.md) - Check if modkit exists for vehicle

## Source

Defined in: `server/[Data - No Save Needed]/_modkit.lua`
