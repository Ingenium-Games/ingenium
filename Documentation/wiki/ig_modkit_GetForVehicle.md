# ig.modkit.GetForVehicle

## Description

Performs getforvehicle operation

## Signature

```lua
function ig.modkit.GetForVehicle(vehicleHash)
```

## Parameters

- **`vehicleHash`**: any
- **`callback`**: function

## Example

```lua
-- Get forvehicle data
local result = ig.modkit.GetForVehicle(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Data]/_game_data_helpers.lua`
