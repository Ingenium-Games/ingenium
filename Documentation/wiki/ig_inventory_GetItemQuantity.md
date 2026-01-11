# ig.inventory.GetItemQuantity

## Description

Retrieves and returns itemquantity data

## Signature

```lua
function ig.inventory.GetItemQuantity(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get itemquantity data
local result = ig.inventory.GetItemQuantity("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_inventory.lua`
