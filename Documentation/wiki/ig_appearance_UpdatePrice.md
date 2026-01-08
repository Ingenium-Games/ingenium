# ig.appearance.UpdatePrice

## Description

====================================================================================--

## Signature

```lua
function ig.appearance.UpdatePrice(jobName, category, itemId, price)
```

## Parameters

- **`jobName`**: string The name of the job
- **`category`**: string The category (e.g., "hair", "clothing")
- **`itemId`**: string|number The item identifier
- **`price`**: number The new price

## Example

```lua
-- Example usage of ig.appearance.UpdatePrice
local result = ig.appearance.UpdatePrice(jobName, category, itemId, price)
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `server/[Appearance]/_pricing.lua`
