# ig.camera.PointAtEntity

## Description

Points a camera at a specific entity with optional positional offset.

## Signature

```lua
function ig.camera.PointAtEntity(camera, entity, offsetX, offsetY, offsetZ, smoothTransition)
```

## Parameters

- **`camera`**: number - The camera handle
- **`entity`**: number - The entity to point at
- **`offsetX`**: number (optional) - X offset from entity center (default: 0.0)
- **`offsetY`**: number (optional) - Y offset from entity center (default: 0.0)
- **`offsetZ`**: number (optional) - Z offset from entity center (default: 0.0)
- **`smoothTransition`**: boolean (optional) - Whether to smoothly transition (default: true)

## Returns

None

## Example

```lua
-- Create a camera and point it at a vehicle with an offset
local camera = ig.camera.Basic(100.0, 200.0, 30.0)
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
ig.camera.PointAtEntity(camera, vehicle, 0.0, 0.0, 2.0, true)
```

## Source

Defined in: `client/_cameras.lua`
