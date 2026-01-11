# ig.voip.GetDistance

## Description

Retrieves and returns distance data

## Signature

```lua
function ig.voip.GetDistance(x1, y1, z1, x2, y2, z2)
```

## Parameters

- **`x1`**: any
- **`y1`**: any
- **`z1`**: any
- **`x2`**: number
- **`y2`**: number
- **`z2`**: number

## Example

```lua
-- Get distance data
local result = ig.voip.GetDistance(value, value, value, 100, 100, 100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `shared/[Voice]/_voip.lua`
