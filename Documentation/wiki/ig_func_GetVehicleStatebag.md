# ig.func.GetVehicleStatebag

## Description

Retrieves the complete statebag (all state variables) from a vehicle entity. This function dynamically iterates through all statebag properties without hardcoding specific keys, ensuring full state capture even for custom properties added by other scripts.

**Scope:** Client/Server
**Namespace:** ig.func
**Category:** Vehicle Utilities

## Signature

```lua
function ig.func.GetVehicleStatebag(vehicle)
    local statebag = {}
    local entityStatebag = GetEntityStatebag(vehicle)
    
    if entityStatebag then
        for key, value in pairs(entityStatebag) do
            statebag[key] = value
        end
    end
    
    return statebag
end
```

## Parameters

- **`vehicle`**: `number` - The vehicle entity handle

## Returns

- **`table`** - Complete statebag data with all state variables

## Example

```lua
-- Get complete vehicle statebag
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
if vehicle and vehicle ~= 0 then
    local statebag = ig.func.GetVehicleStatebag(vehicle)
    
    -- Access any statebag property
    for key, value in pairs(statebag) do
        print(key .. ": " .. tostring(value))
    end
end
```

## Related Functions

- [ig.func.SetVehicleStatebag](ig_func_SetVehicleStatebag.md) - Restore statebag to a vehicle
- [ig.func.GetVehicleCondition](ig_func_GetVehicleCondition.md) - Get vehicle damage/condition
- [ig.func.GetVehicleModifications](ig_func_GetVehicleModifications.md) - Get vehicle modifications

## Use Cases

- **Vehicle Persistence**: Capture complete vehicle state before despawn
- **Vehicle Restoration**: Restore full state when respawning vehicles
- **State Synchronization**: Share vehicle state across different systems
- **Custom Properties**: Access script-specific properties stored on vehicle
- **Debugging**: Inspect all statebag properties for troubleshooting

## Notes

- Uses `GetEntityStatebag()` FiveM native for dynamic iteration
- Captures ALL statebag properties without hardcoding
- Returns empty table if statebag doesn't exist
- Can be called on any entity type (not just vehicles)
- Server-side equivalent also available for authority checks

## Server Implementation

On the server, this function is used to read the authoritative vehicle state:

```lua
-- Server reads statebag directly from vehicle entity
local vehicle = NetworkGetEntityFromNetworkId(netId)
if vehicle and DoesEntityExist(vehicle) then
    local statebag = ig.func.GetVehicleStatebag(vehicle)
    -- Server has authoritative state now
end
```

