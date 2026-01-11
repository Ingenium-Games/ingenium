# ig.item.CanCraft

## Description

Checks if an item can be crafted by verifying if a crafting recipe exists for the specified item.

## Signature

```lua
function ig.item.CanCraft(xPlayer, itemName)
```

## Parameters

- **`xPlayer`**: any
- **`itemName`**: any

## Example

```lua
-- Check if item is craftable
local craftable = ig.item.CanCraft("lockpick")
if craftable then
    print("Lockpick can be crafted")
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
