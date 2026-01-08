# ig.drop.Deactivate

## Description

Already active?

## Signature

```lua
function ig.drop.Deactivate(netId)
```

## Parameters

- **`netId`**: number Network ID of the drop

## Example

```lua
-- Example usage of ig.drop.Deactivate
local result = ig.drop.Deactivate(netId)
```

## Important Notes

> ⚠️ **Security**: This function accesses player identifiers or can ban/kick players. Ensure proper permission checks.

## Related Functions

- [ig.drop.Activate](ig_drop_Activate.md)
- [ig.drop.CleanupOld](ig_drop_CleanupOld.md)
- [ig.drop.Create](ig_drop_Create.md)
- [ig.drop.MergeDropsForSave](ig_drop_MergeDropsForSave.md)
- [ig.drop.Remove](ig_drop_Remove.md)

## Source

Defined in: `server/[Data - Save to File]/_drops.lua`
