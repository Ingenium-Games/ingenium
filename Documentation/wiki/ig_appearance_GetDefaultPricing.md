# ig.appearance.GetDefaultPricing

## Description

Get pricing data for a job, with fallback to default

## Signature

```lua
function ig.appearance.GetDefaultPricing()
```

## Parameters

*No parameters*

## Example

```lua
-- Get defaultpricing data
local result = ig.appearance.GetDefaultPricing()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Appearance]/_pricing.lua`
