# ig.appearance.GetProp

## Description

Set all props

## Signature

```lua
function ig.appearance.GetProp(propId)
```

## Parameters

- **`texture`**: number Texture index
- **`props`**: table Array of props {{prop_id, drawable, texture}, ...}
- **`propId`**: number Prop ID

## Example

```lua
-- Example usage of ig.appearance.GetProp
local result = ig.appearance.GetProp()
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
