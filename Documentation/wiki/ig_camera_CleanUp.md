# ig.camera.CleanUp

## Description

Cleans up and destroys a camera instance, freeing its resources.

## Signature

```lua
function ig.camera.CleanUp(camera)
```

## Parameters

- **`camera`**: number

## Example

```lua
-- Clean up camera
local camera = ig.camera.Basic(100.0, 200.0, 30.0, 0.0, 0.0, 90.0, 50.0)
-- ... use camera ...
ig.camera.CleanUp(camera)
```

## Source

Defined in: `client/_cameras.lua`
