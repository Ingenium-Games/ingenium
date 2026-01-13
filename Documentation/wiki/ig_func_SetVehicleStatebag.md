# ig.func.SetVehicleStatebag

## Description

Restores a complete statebag (all state variables) to a vehicle entity. This function applies all state properties from a saved statebag, restoring the vehicle to a previously captured state without hardcoding specific keys.

**Scope:** Client/Server
**Namespace:** ig.func
**Category:** Vehicle Utilities

## Signature

```lua
function ig.func.SetVehicleStatebag(vehicle, statebag)
    if not statebag or not next(statebag) then
        return
    end
    
    for key, value in pairs(statebag) do
        if value ~= nil then
            Entity(vehicle).state[key] = value
        end
    end
end
```

## Parameters

- **`vehicle`**: `number` - The vehicle entity handle
- **`statebag`**: `table` - The statebag data to restore (from GetVehicleStatebag)

## Returns

None

## Example

```lua
-- Capture vehicle state
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
local savedStatebag = ig.func.GetVehicleStatebag(vehicle)

-- Later, restore to another vehicle
local newVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
ig.func.SetVehicleStatebag(newVehicle, savedStatebag)
```

## Related Functions

- [ig.func.GetVehicleStatebag](ig_func_GetVehicleStatebag.md) - Retrieve statebag from vehicle
- [ig.func.SetVehicleCondition](ig_func_SetVehicleCondition.md) - Restore vehicle damage/condition
- [ig.func.SetVehicleModifications](ig_func_SetVehicleModifications.md) - Restore vehicle modifications

## Use Cases

- **Vehicle Persistence**: Restore complete vehicle state after respawn
- **Vehicle Cloning**: Copy all state from one vehicle to another
- **State Recovery**: Restore vehicle state from database/cache
- **Vehicle Customization**: Apply saved configurations to new vehicles
- **System Integration**: Share state between vehicle scripts

## Notes

- Skips nil values to prevent overwriting with empty data
- Uses `Entity(vehicle).state[key]` to set individual properties
- Gracefully handles empty statebag tables
- Can be called on any entity type (not just vehicles)
- Always pair with GetVehicleStatebag for proper state management

## Server Implementation

On the server, this is used when spawning persistent vehicles:

```lua
-- Server restores saved statebag to newly spawned vehicle
local vehicleData = ig.vehicle.GetPersistentVehicle(plate)
if vehicleData and vehicleData.statebag then
    ig.func.SetVehicleStatebag(vehicle, vehicleData.statebag)
end
```

## Safety

- Filters out nil values automatically
- Validates input table exists before iteration
- No error handling needed; gracefully fails on invalid input
- Safe to call with empty or corrupted statebag tables

