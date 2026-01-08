# ig.validation.ValidateAndUnpack

## Description

Log to server console

## Signature

```lua
function ig.validation.ValidateAndUnpack(source, inventory)
```

## Parameters

- **`source`**: number - Player source for error reporting (can be nil for non-player entities)
- **`inventory`**: table - Inventory array to validate and process

## Example

```lua
-- Example usage of ig.validation.ValidateAndUnpack
local result = ig.validation.ValidateAndUnpack(source, inventory)
```

## Related Functions

- [ig.validation.GetItemQuantities](ig_validation_GetItemQuantities.md)
- [ig.validation.IsValidItem](ig_validation_IsValidItem.md)
- [ig.validation.LogAndBanExploiter](ig_validation_LogAndBanExploiter.md)
- [ig.validation.ValidateInventory](ig_validation_ValidateInventory.md)
- [ig.validation.ValidateInventoryIntegrity](ig_validation_ValidateInventoryIntegrity.md)

## Source

Defined in: `server/[Validation]/_validator.lua`
