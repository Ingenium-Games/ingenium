# ig.item.Search

## Description

Check if player has required items for crafting

## Signature

```lua
function ig.item.Search(pattern)
```

## Parameters

- **`xPlayer`**: table Player object
- **`itemName`**: string Item to craft
- **`pattern`**: string Search pattern

## Example

```lua
-- Example usage of ig.item.Search
local result = ig.item.Search(pattern)
```

## Related Functions

- [ig.item.CanDegrade](ig_item_CanDegrade.md)
- [ig.item.CanHotkey](ig_item_CanHotkey.md)
- [ig.item.CanStack](ig_item_CanStack.md)
- [ig.item.Exists](ig_item_Exists.md)
- [ig.item.GetAbout](ig_item_GetAbout.md)

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
