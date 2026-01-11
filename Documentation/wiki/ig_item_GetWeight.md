# ig.item.GetWeight

## Description

Retrieves and returns weight data

## Signature

```lua
function ig.item.GetWeight(name)
```

## Parameters

- **`name`**: number

## Example

```lua
-- Get weight data
local result = ig.item.GetWeight(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
