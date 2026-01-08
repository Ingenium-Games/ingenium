# ig.inventory.HasItem

## Description

gets triggered via ig.nui to set the pulled current contents, then this can be used to confirm if items exist prior to menu activations.

## Signature

```lua
function ig.inventory.HasItem(name)
```

## Parameters

- **`name`**: any

## Example

```lua
-- Example usage of ig.inventory.HasItem
local result = ig.inventory.HasItem(name)
```

## Related Functions

- [ig.inventory.GetInventory](ig_inventory_GetInventory.md)
- [ig.inventory.GetItemData](ig_inventory_GetItemData.md)
- [ig.inventory.GetItemFromPosition](ig_inventory_GetItemFromPosition.md)
- [ig.inventory.GetItemMeta](ig_inventory_GetItemMeta.md)
- [ig.inventory.GetItemQuality](ig_inventory_GetItemQuality.md)

## Source

Defined in: `client/_inventory.lua`
