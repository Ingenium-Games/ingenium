# ig.appearance.RotateCamera

## Description

Set camera view mode

## Signature

```lua
function ig.appearance.RotateCamera(degrees)
```

## Parameters

- **`mode`**: string Camera mode: "face", "body", "legs", "full
- **`degrees`**: number Degrees to rotate (positive = right, negative = left)

## Example

```lua
-- Example usage of ig.appearance.RotateCamera
local result = ig.appearance.RotateCamera(degrees)
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
