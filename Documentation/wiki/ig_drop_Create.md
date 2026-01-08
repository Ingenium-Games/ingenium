# ig.drop.Create

## Description

====================================================================================--

## Signature

```lua
function ig.drop.Create(coords, items, model, targetPlayer, isDeadDrop)
```

## Parameters

- **`coords`**: table {x, y, z, h}
- **`items`**: table Array of items to add [{Item, Quantity, Quality, Weapon, Meta}]
- **`model`**: string|nil Optional model hash, uses default if nil
- **`targetPlayer`**: number|nil Optional target player source to notify
- **`isDeadDrop`**: boolean|nil If true, notifies player without blip (for secret drops)

## Example

```lua
-- Example usage of ig.drop.Create
local entity = ig.drop.Create(params)
```

## Important Notes

> ⚠️ **Security**: This function accesses player identifiers or can ban/kick players. Ensure proper permission checks.

## Related Functions

- [ig.drop.Activate](ig_drop_Activate.md)
- [ig.drop.CleanupOld](ig_drop_CleanupOld.md)
- [ig.drop.Deactivate](ig_drop_Deactivate.md)
- [ig.drop.MergeDropsForSave](ig_drop_MergeDropsForSave.md)
- [ig.drop.Remove](ig_drop_Remove.md)

## Source

Defined in: `server/[Data - Save to File]/_drops.lua`
