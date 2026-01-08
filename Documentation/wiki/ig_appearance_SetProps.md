# ig.appearance.SetProps

## Description

====================================================================================--

## Signature

```lua
function ig.appearance.SetProps(props)
```

## Parameters

- **`propId`**: number Prop ID (0, 1, 2, 6, 7)
- **`drawable`**: number Drawable index (-1 to remove)
- **`texture`**: number Texture index
- **`props`**: table Array of props {{prop_id, drawable, texture}, ...}

## Example

```lua
-- Example usage of ig.appearance.SetProps
ig.appearance.SetProps(value)
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
