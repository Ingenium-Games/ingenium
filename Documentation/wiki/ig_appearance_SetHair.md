# ig.appearance.SetHair

## Description

Set all head overlays

## Signature

```lua
function ig.appearance.SetHair(style, color, highlight)
```

## Parameters

- **`overlays`**: table Table of overlays {[0]={style, opacity, color}, ...}
- **`style`**: number Hair style index
- **`color`**: number Primary color
- **`highlight`**: number Highlight color

## Example

```lua
-- Example usage of ig.appearance.SetHair
ig.appearance.SetHair(value)
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
