# ig.pick.CleanupOld

## Description

Check if pickup is active

## Signature

```lua
function ig.pick.CleanupOld(maxAge)
```

## Parameters

- **`uuid`**: string Pickup UUID
- **`maxAge`**: number|nil Max age in seconds (uses config if nil)

## Example

```lua
-- Example usage of ig.pick.CleanupOld
local result = ig.pick.CleanupOld(maxAge)
```

## Related Functions

- [ig.pick.Activate](ig_pick_Activate.md)
- [ig.pick.Collect](ig_pick_Collect.md)
- [ig.pick.Create](ig_pick_Create.md)
- [ig.pick.CreateLoot](ig_pick_CreateLoot.md)
- [ig.pick.CreateZone](ig_pick_CreateZone.md)

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
