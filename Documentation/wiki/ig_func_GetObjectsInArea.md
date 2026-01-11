# ig.func.GetObjectsInArea

## Description

Returns Objects within the designated radius.

## Signature

```lua
function ig.func.GetObjectsInArea(ords, radius, minimal)
```

## Parameters

- **`ords`**: any
- **`radius`**: any
- **`minimal`**: any

## Example

```lua
-- Get objectsinarea data
local result = ig.func.GetObjectsInArea(value, value, value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_functions.lua`
