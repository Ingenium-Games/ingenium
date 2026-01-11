# ig.camera.NewName

## Description

Generates a unique camera identifier name. Creates a random name in the format "CAM-XXXXX-XXXXX-XXXXX-XXXXX" and registers the camera in the cameras table.

## Signature

```lua
function ig.camera.NewName(t)
```

## Parameters

- **`t`**: table

## Example

```lua
-- Generate unique camera name
local cameraData = { type = "DEFAULT_SCRIPTED_CAMERA" }
local name = ig.camera.NewName(cameraData)
print("Generated camera name:", name)
```

## Source

Defined in: `client/_cameras.lua`
