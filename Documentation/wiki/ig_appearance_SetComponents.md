# ig.appearance.SetComponents

## Description

Get current eye color

## Signature

```lua
function ig.appearance.SetComponents(components)
```

## Parameters

- **`componentId`**: number Component ID (0-11)
- **`drawable`**: number Drawable index
- **`texture`**: number Texture index
- **`palette`**: number Palette index (default 0)
- **`components`**: table Array of components {{component_id, drawable, texture}, ...}

## Example

```lua
-- Example usage of ig.appearance.SetComponents
ig.appearance.SetComponents(value)
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
