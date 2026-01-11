# ig.voip.GetSurroundingGridCells

## Description

Calculate grid cell from position (for grid-based proximity)

## Signature

```lua
function ig.voip.GetSurroundingGridCells(gridX, gridY)
```

## Parameters

- **`gridX`**: number
- **`gridY`**: number

## Example

```lua
-- Get surroundinggridcells data
local result = ig.voip.GetSurroundingGridCells(123, 123)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `shared/[Voice]/_voip.lua`
