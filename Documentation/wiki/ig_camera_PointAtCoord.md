# ig.camera.PointAtCoord

## Description

Points a camera at specific world coordinates.

## Signature

```lua
function ig.camera.PointAtCoord(camera, x, y, z)
```

## Parameters

- **`camera`**: number - The camera handle
- **`x`**: number - World X coordinate
- **`y`**: number - World Y coordinate
- **`z`**: number - World Z coordinate

## Returns

None

## Example

```lua
-- Create a camera and point it at coordinates
local camera = ig.camera.Basic(100.0, 200.0, 30.0)
ig.camera.PointAtCoord(camera, 150.0, 250.0, 35.0)
```

## Source

Defined in: `client/_cameras.lua`
