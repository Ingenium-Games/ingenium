# ig.validation.ValidateInventoryIntegrity

## Description

Validate entire inventory array

## Signature

```lua
function ig.validation.ValidateInventoryIntegrity(beforePlayer, beforeExternal, afterPlayer, afterExternal)
```

## Parameters

- **`inventory`**: table - Inventory to validate
- **`beforePlayer`**: table - Player inventory before operation
- **`beforeExternal`**: table - External inventory before operation (can be nil)
- **`afterPlayer`**: table - Player inventory after operation
- **`afterExternal`**: table - External inventory after operation (can be nil)

## Example

```lua
-- Example usage of ig.validation.ValidateInventoryIntegrity
local result = ig.validation.ValidateInventoryIntegrity(beforePlayer, beforeExternal, afterPlayer, afterExternal)
```

## Related Functions

- [ig.validation.GetItemQuantities](ig_validation_GetItemQuantities.md)
- [ig.validation.IsValidItem](ig_validation_IsValidItem.md)
- [ig.validation.LogAndBanExploiter](ig_validation_LogAndBanExploiter.md)
- [ig.validation.ValidateAndUnpack](ig_validation_ValidateAndUnpack.md)
- [ig.validation.ValidateInventory](ig_validation_ValidateInventory.md)

## Source

Defined in: `server/[Validation]/_validator.lua`
