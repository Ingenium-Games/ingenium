# ig.appearance.SetHeadOverlay

## Description

Get current face features

## Signature

```lua
function ig.appearance.SetHeadOverlay(overlayId, style, opacity, color, secondColor)
```

## Parameters

- **`overlayId`**: number Overlay ID (0-12)
- **`style`**: number Style index
- **`opacity`**: number Opacity (0.0-1.0)
- **`color`**: number Color index
- **`secondColor`**: number|nil Secondary color index (for certain overlays)

## Example

```lua
-- Example usage of ig.appearance.SetHeadOverlay
ig.appearance.SetHeadOverlay(value)
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
