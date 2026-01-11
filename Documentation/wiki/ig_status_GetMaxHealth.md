# ig.status.GetMaxHealth

## Description

Retrieves and returns maxhealth data

## Signature

```lua
function ig.status.GetMaxHealth()
```

## Parameters

*No parameters*

## Example

```lua
-- Get maxhealth data
local result = ig.status.GetMaxHealth()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_status.lua`
