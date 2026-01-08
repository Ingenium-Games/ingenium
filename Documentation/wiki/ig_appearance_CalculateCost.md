# ig.appearance.CalculateCost

## Description

RESOURCE STOP HANDLER

## Signature

```lua
function ig.appearance.CalculateCost(jobName, oldAppearance, newAppearance)
```

## Parameters

- **`pricing`**: table The pricing data
- **`category`**: string The category to check
- **`jobName`**: string|nil The job name for pricing
- **`oldAppearance`**: table The original appearance
- **`newAppearance`**: table The new appearance

## Example

```lua
-- Example usage of ig.appearance.CalculateCost
local result = ig.appearance.CalculateCost(jobName, oldAppearance, newAppearance)
```

## Related Functions

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)

## Source

Defined in: `server/[Appearance]/_pricing.lua`
