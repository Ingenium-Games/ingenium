# ig.inventory.GetItemData

## Description

Retrieves and returns itemdata data

## Signature

```lua
function ig.inventory.GetItemData(position)
```

## Parameters

- **`position`**: number

## Example

```lua
-- Get itemdata data
local result = ig.inventory.GetItemData(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_inventory.lua`
