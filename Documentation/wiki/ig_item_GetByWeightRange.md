# ig.item.GetByWeightRange

## Description

Retrieves and returns byweightrange data

## Signature

```lua
function ig.item.GetByWeightRange(minWeight, maxWeight)
```

## Parameters

- **`minWeight`**: any
- **`maxWeight`**: any

## Example

```lua
-- Get byweightrange data
local result = ig.item.GetByWeightRange(value, value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
