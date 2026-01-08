# ig.pick.CreateLoot

## Description

Sync to clients

## Signature

```lua
function ig.pick.CreateLoot(coords, items, model, respawnTime)
```

## Parameters

- **`eventName`**: string Event name to search for
- **`coords`**: table Coordinates
- **`items`**: table Array of items to give
- **`model`**: number|nil Model hash (uses default if nil)
- **`respawnTime`**: number|nil Respawn time in ms (no respawn if nil)

## Example

```lua
-- Example usage of ig.pick.CreateLoot
local entity = ig.pick.CreateLoot(params)
```

## Related Functions

- [ig.pick.Activate](ig_pick_Activate.md)
- [ig.pick.CleanupOld](ig_pick_CleanupOld.md)
- [ig.pick.Collect](ig_pick_Collect.md)
- [ig.pick.Create](ig_pick_Create.md)
- [ig.pick.CreateZone](ig_pick_CreateZone.md)

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
