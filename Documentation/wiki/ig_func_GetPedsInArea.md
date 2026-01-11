# ig.func.GetPedsInArea

## Description

Returns All Peds (including Players) within the designated radius.

## Signature

```lua
function ig.func.GetPedsInArea(ords, radius, minimal)
```

## Parameters

- **`ords`**: any
- **`radius`**: any
- **`minimal`**: any

## Example

```lua
-- Get pedsinarea data
local result = ig.func.GetPedsInArea(value, value, value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_functions.lua`
