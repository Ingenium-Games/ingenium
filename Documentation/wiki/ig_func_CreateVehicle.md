# ig.func.CreateVehicle

## Description

Creates a new vehicle entity at the specified coordinates with optional custom data. Returns the entity handle and network ID.

## Signature

```lua
function ig.func.CreateVehicle(name, x, y, z, h, data)
```

## Parameters

- **`name`**: string
- **`x`**: any
- **`y`**: any
- **`z`**: any
- **`h`**: any

## Example

```lua
-- Example 1: Create a vehicle by model name
local vehicle, netId = ig.func.CreateVehicle("adder", 100.0, 200.0, 30.0, 90.0)
if vehicle then
    print("Created vehicle with network ID:", netId)
end

-- Example 2: Create a vehicle by hash
local vehicleHash = GetHashKey("t20")
local vehicle2 = ig.func.CreateVehicle(vehicleHash, 150.0, 250.0, 30.0, 180.0)

-- Example 3: Create vehicle with custom data
local customData = { color = "red", tuning = true }
local vehicle3, netId3 = ig.func.CreateVehicle("zentorno", 200.0, 300.0, 30.0, 0.0, customData)
```

## Source

Defined in: `client/_functions.lua`
