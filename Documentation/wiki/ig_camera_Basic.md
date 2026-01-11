# ig.camera.Basic

## Description

Creates a basic scripted camera with specified position, rotation, and field of view.

## Signature

```lua
function ig.camera.Basic(px, py, pz, rx, ry, rz, fov, l1, l2)
```

## Parameters

- **`px`**: number
- **`py`**: number
- **`pz`**: number
- **`rx`**: number
- **`ry`**: number
- **`rz`**: number
- **`fov`**: number
- **`l1`**: boolean
- **`l2`**: number

## Example

```lua
-- Create a basic camera
local camera = ig.camera.Basic(100.0, 200.0, 30.0, 0.0, 0.0, 90.0, 50.0)
SetCamActive(camera, true)
RenderScriptCams(true, false, 0, true, false)
```

## Source

Defined in: `client/_cameras.lua`
