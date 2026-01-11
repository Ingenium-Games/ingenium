# ig.appearance.GetPricing

## Description

Retrieves and returns pricing data

## Signature

```lua
function ig.appearance.GetPricing(jobName)
```

## Parameters

- **`jobName`**: any

## Example

```lua
-- Get pricing data
local result = ig.appearance.GetPricing(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Appearance]/_pricing.lua`
