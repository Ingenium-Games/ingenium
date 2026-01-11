# ig.status.GetThirst

## Description

Retrieves and returns thirst data

## Signature

```lua
function ig.status.GetThirst()
```

## Parameters

*No parameters*

## Example

```lua
-- Get thirst data
local result = ig.status.GetThirst()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_status.lua`
