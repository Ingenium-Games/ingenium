# ig.pick.UpdateData

## Description

Cleanup old pickups

## Signature

```lua
function ig.pick.UpdateData(uuid, data)
```

## Parameters

- **`maxAge`**: number|nil Max age in seconds (uses config if nil)
- **`uuid`**: string Pickup UUID
- **`data`**: table New data to merge

## Example

```lua
-- Example usage of ig.pick.UpdateData
local result = ig.pick.UpdateData(uuid, data)
```

## Important Notes

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.pick.Activate](ig_pick_Activate.md)
- [ig.pick.CleanupOld](ig_pick_CleanupOld.md)
- [ig.pick.Collect](ig_pick_Collect.md)
- [ig.pick.Create](ig_pick_Create.md)
- [ig.pick.CreateLoot](ig_pick_CreateLoot.md)

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
