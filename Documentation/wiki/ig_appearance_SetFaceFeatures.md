# ig.appearance.SetFaceFeatures

## Description

====================================================================================--

## Signature

```lua
function ig.appearance.SetFaceFeatures(features)
```

## Parameters

- **`index`**: number Feature index (0-19)
- **`value`**: number Feature value (-1.0 to 1.0)
- **`features`**: table Table of features {[0]=value, [1]=value, ...}

## Example

```lua
-- Example usage of ig.appearance.SetFaceFeatures
ig.appearance.SetFaceFeatures(value)
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `client/_appearance.lua`
