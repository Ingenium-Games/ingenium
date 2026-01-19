# ig.vehicle.GetDisplayName

## Description

Returns the human-readable display name (label) for a vehicle based on its hash. This is useful for UI displays where you need to show the vehicle's name to players. Returns "Unknown" if the vehicle hash is not found in the registry.

## Signature

```lua
function ig.vehicle.GetDisplayName(hash)
```

## Parameters

- **`hash`**: number - The vehicle model hash

## Returns

- **`string`** - Vehicle display name (label) or "Unknown" if not found

## Example

```lua
-- Get display name for a vehicle
local vehicleHash = GetHashKey("adder")
local displayName = ig.vehicle.GetDisplayName(vehicleHash)
print("Vehicle Display Name:", displayName)  -- Output: "Truffade Adder"

-- Use in notification
local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
if playerVehicle ~= 0 then
    local model = GetEntityModel(playerVehicle)
    local name = ig.vehicle.GetDisplayName(model)
    ig.func.Notify(string.format("You are driving a %s", name), "info", 3000)
end

-- Safe lookup with fallback
local hash = GetHashKey("unknown_vehicle")
local name = ig.vehicle.GetDisplayName(hash)  -- Returns "Unknown"
```

## Related Functions

- [ig.vehicle.GetAll](ig_vehicle_GetAll.md) - Get all vehicles
- [ig.vehicle.GetByHash](ig_vehicle_GetByHash.md) - Get vehicle data by hash
- [ig.vehicle.GetByName](ig_vehicle_GetByName.md) - Get vehicle by model name
- [ig.weapon.GetDisplayName](ig_weapon_GetDisplayName.md) - Get weapon display name

## Source

Defined in: `server/[Data - No Save Needed]/_vehicle.lua`
