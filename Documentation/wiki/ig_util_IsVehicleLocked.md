# ig.util.IsVehicleLocked

## Description

Checks if a vehicle is locked by comparing its lock status value.

## Signature

```lua
function ig.util.IsVehicleLocked(vehicle)
```

## Parameters

- **`vehicle`**: number - The vehicle handle

## Returns

- **`boolean`** - `true` if the vehicle is locked (lock status > 1), `false` otherwise

## Example

```lua
-- Check if a vehicle is locked
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
if ig.util.IsVehicleLocked(vehicle) then
    print("Vehicle is locked")
else
    print("Vehicle is unlocked")
end
```

## Source

Defined in: `shared/[Tools]/_util.lua`
