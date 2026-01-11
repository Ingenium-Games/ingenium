# ig.status.GetHealth

## Description

Retrieves and returns health data

## Signature

```lua
function ig.status.GetHealth()
```

## Parameters

*No parameters*

## Example

```lua
-- Get health data
local result = ig.status.GetHealth()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_status.lua`
