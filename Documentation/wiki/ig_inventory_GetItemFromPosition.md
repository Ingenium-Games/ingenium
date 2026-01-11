# ig.inventory.GetItemFromPosition

## Description

Retrieves and returns itemfromposition data

## Signature

```lua
function ig.inventory.GetItemFromPosition(position)
```

## Parameters

- **`position`**: number

## Example

```lua
-- Get itemfromposition data
local result = ig.inventory.GetItemFromPosition(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_inventory.lua`
