# ig.camera.Advanced

## Description

Creates an advanced scripted camera with custom type, position, rotation, and field of view.

## Signature

```lua
function ig.camera.Advanced(type, px, py, pz, rx, ry, rz, fov, l1, l2)
```

## Parameters

- **`type`**: string
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
-- Create an advanced camera
local camera = ig.camera.Advanced("FIRST_PERSON_CAM", 100.0, 200.0, 30.0, 0.0, 0.0, 90.0, 50.0)
SetCamActive(camera, true)
```

## Source

Defined in: `client/_cameras.lua`
