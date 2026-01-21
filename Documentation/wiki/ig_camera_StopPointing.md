# ig.camera.StopPointing

## Description

Stops the camera from pointing at an entity or coordinate.

## Signature

```lua
function ig.camera.StopPointing(camera)
```

## Parameters

- **`camera`**: number - The camera handle

## Returns

None

## Example

```lua
-- Stop the camera from tracking
local camera = ig.camera.Basic(100.0, 200.0, 30.0)
ig.camera.PointAtEntity(camera, someEntity)
Wait(5000)
ig.camera.StopPointing(camera)
```

## Source

Defined in: `client/_cameras.lua`
