# ig.appearance.GetComponent

## Description

Set all components

## Signature

```lua
function ig.appearance.GetComponent(componentId)
```

## Parameters

- **`componentId`**: number Component ID (0-11)
- **`drawable`**: number Drawable index
- **`texture`**: number Texture index
- **`palette`**: number Palette index (default 0)
- **`components`**: table Array of components {{component_id, drawable, texture}, ...}
- **`componentId`**: number Component ID

## Example

```lua
-- Example usage of ig.appearance.GetComponent
local result = ig.appearance.GetComponent()
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
