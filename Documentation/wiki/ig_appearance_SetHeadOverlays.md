# ig.appearance.SetHeadOverlays

## Description

====================================================================================--

## Signature

```lua
function ig.appearance.SetHeadOverlays(overlays)
```

## Parameters

- **`overlayId`**: number Overlay ID (0-12)
- **`style`**: number Style index
- **`opacity`**: number Opacity (0.0-1.0)
- **`color`**: number Color index
- **`secondColor`**: number|nil Secondary color index (for certain overlays)
- **`overlays`**: table Table of overlays {[0]={style, opacity, color}, ...}

## Example

```lua
-- Example usage of ig.appearance.SetHeadOverlays
ig.appearance.SetHeadOverlays(value)
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
