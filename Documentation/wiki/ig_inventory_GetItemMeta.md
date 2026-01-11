# ig.inventory.GetItemMeta

## Description

Retrieves and returns itemmeta data

## Signature

```lua
function ig.inventory.GetItemMeta(position)
```

## Parameters

- **`position`**: number

## Example

```lua
-- Get itemmeta data
local result = ig.inventory.GetItemMeta(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_inventory.lua`
