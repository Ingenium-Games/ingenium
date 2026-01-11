# ig.item.GetByValueRange

## Description

Retrieves and returns byvaluerange data

## Signature

```lua
function ig.item.GetByValueRange(minValue, maxValue)
```

## Parameters

- **`minValue`**: any
- **`maxValue`**: any

## Example

```lua
-- Get byvaluerange data
local result = ig.item.GetByValueRange(value, value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
