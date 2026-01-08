# ig.pick.Deactivate

## Description

Sort by distance

## Signature

```lua
function ig.pick.Deactivate(uuid, duration)
```

## Parameters

- **`model`**: number Model hash
- **`uuid`**: string Pickup UUID
- **`duration`**: number|nil Duration in ms (permanent if nil)

## Example

```lua
-- Example usage of ig.pick.Deactivate
local result = ig.pick.Deactivate(uuid, duration)
```

## Related Functions

- [ig.pick.Activate](ig_pick_Activate.md)
- [ig.pick.CleanupOld](ig_pick_CleanupOld.md)
- [ig.pick.Collect](ig_pick_Collect.md)
- [ig.pick.Create](ig_pick_Create.md)
- [ig.pick.CreateLoot](ig_pick_CreateLoot.md)

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
