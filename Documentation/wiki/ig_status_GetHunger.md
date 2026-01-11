# ig.status.GetHunger

## Description

Retrieves and returns hunger data

## Signature

```lua
function ig.status.GetHunger()
```

## Parameters

*No parameters*

## Example

```lua
-- Get hunger data
local result = ig.status.GetHunger()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_status.lua`
