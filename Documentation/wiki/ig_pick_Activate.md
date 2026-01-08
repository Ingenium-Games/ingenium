# ig.pick.Activate

## Description

Sync to clients

## Signature

```lua
function ig.pick.Activate(uuid)
```

## Parameters

- **`uuid`**: string Pickup UUID
- **`duration`**: number|nil Duration in ms (permanent if nil)
- **`uuid`**: string Pickup UUID

## Example

```lua
-- Example usage of ig.pick.Activate
local result = ig.pick.Activate(uuid)
```

## Related Functions

- [ig.pick.CleanupOld](ig_pick_CleanupOld.md)
- [ig.pick.Collect](ig_pick_Collect.md)
- [ig.pick.Create](ig_pick_Create.md)
- [ig.pick.CreateLoot](ig_pick_CreateLoot.md)
- [ig.pick.CreateZone](ig_pick_CreateZone.md)

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
