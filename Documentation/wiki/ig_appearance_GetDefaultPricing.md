# ig.appearance.GetDefaultPricing

## Description

Get pricing data for a job, with fallback to default

## Signature

```lua
function ig.appearance.GetDefaultPricing()
```

## Parameters

- **`jobName`**: string|nil The name of the job (nil for default)

## Example

```lua
-- Example usage of ig.appearance.GetDefaultPricing
local result = ig.appearance.GetDefaultPricing()
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `server/[Appearance]/_pricing.lua`
