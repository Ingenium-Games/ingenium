# ig.status.GetStress

## Description

Retrieves and returns stress data

## Signature

```lua
function ig.status.GetStress()
```

## Parameters

*No parameters*

## Example

```lua
-- Get stress data
local result = ig.status.GetStress()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_status.lua`
