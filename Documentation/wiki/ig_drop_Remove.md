# ig.drop.Remove

## Description

Trigger hook event for custom scripts (phone systems, etig.)

## Signature

```lua
function ig.drop.Remove(netId)
```

## Parameters

- **`netId`**: number Network ID of the drop

## Example

```lua
-- Example usage of ig.drop.Remove
ig.drop.Remove(item)
```

## Important Notes

> ⚠️ **Security**: This function accesses player identifiers or can ban/kick players. Ensure proper permission checks.

## Related Functions

- [ig.drop.Activate](ig_drop_Activate.md)
- [ig.drop.CleanupOld](ig_drop_CleanupOld.md)
- [ig.drop.Create](ig_drop_Create.md)
- [ig.drop.Deactivate](ig_drop_Deactivate.md)
- [ig.drop.MergeDropsForSave](ig_drop_MergeDropsForSave.md)

## Source

Defined in: `server/[Data - Save to File]/_drops.lua`
