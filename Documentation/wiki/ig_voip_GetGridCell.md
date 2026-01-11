# ig.voip.GetGridCell

## Description

Calculate distance between two 3D positions

## Signature

```lua
function ig.voip.GetGridCell(x, y)
```

## Parameters

- **`x`**: number
- **`y`**: number

## Example

```lua
-- Get gridcell data
local result = ig.voip.GetGridCell(100, 100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `shared/[Voice]/_voip.lua`
