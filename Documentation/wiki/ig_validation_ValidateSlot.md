# ig.validation.ValidateSlot

## Description

Validate that an item exists in the game's item database

## Signature

```lua
function ig.validation.ValidateSlot(slot, index)
```

## Parameters

- **`itemName`**: string - Name of the item to check
- **`slot`**: table - Inventory slot to validate
- **`index`**: number - Slot index for error reporting

## Example

```lua
-- Example usage of ig.validation.ValidateSlot
local result = ig.validation.ValidateSlot(slot, index)
```

## Related Functions

- [ig.validation.GetItemQuantities](ig_validation_GetItemQuantities.md)
- [ig.validation.IsValidItem](ig_validation_IsValidItem.md)
- [ig.validation.LogAndBanExploiter](ig_validation_LogAndBanExploiter.md)
- [ig.validation.ValidateAndUnpack](ig_validation_ValidateAndUnpack.md)
- [ig.validation.ValidateInventory](ig_validation_ValidateInventory.md)

## Source

Defined in: `server/[Validation]/_validator.lua`
