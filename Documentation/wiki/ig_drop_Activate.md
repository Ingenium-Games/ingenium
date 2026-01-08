# ig.drop.Activate

## Description

Notify target player to remove blip if this was a targeted drop

## Signature

```lua
function ig.drop.Activate(netId)
```

## Parameters

- **`netId`**: number Network ID of the drop

## Example

```lua
-- Example usage of ig.drop.Activate
local result = ig.drop.Activate(netId)
```

## Important Notes

> ⚠️ **Security**: This function accesses player identifiers or can ban/kick players. Ensure proper permission checks.

## Related Functions

- [ig.drop.CleanupOld](ig_drop_CleanupOld.md)
- [ig.drop.Create](ig_drop_Create.md)
- [ig.drop.Deactivate](ig_drop_Deactivate.md)
- [ig.drop.MergeDropsForSave](ig_drop_MergeDropsForSave.md)
- [ig.drop.Remove](ig_drop_Remove.md)

## Source

Defined in: `server/[Data - Save to File]/_drops.lua`
