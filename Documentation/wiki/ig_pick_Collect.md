# ig.pick.Collect

## Description

Create a loot pickup (common pattern)

## Signature

```lua
function ig.pick.Collect(source, uuid)
```

## Parameters

- **`coords`**: table Coordinates
- **`items`**: table Array of items to give
- **`model`**: number|nil Model hash (uses default if nil)
- **`respawnTime`**: number|nil Respawn time in ms (no respawn if nil)
- **`source`**: number Player source
- **`uuid`**: string Pickup UUID

## Example

```lua
-- Example usage of ig.pick.Collect
local result = ig.pick.Collect(source, uuid)
```

## Related Functions

- [ig.pick.Activate](ig_pick_Activate.md)
- [ig.pick.CleanupOld](ig_pick_CleanupOld.md)
- [ig.pick.Create](ig_pick_Create.md)
- [ig.pick.CreateLoot](ig_pick_CreateLoot.md)
- [ig.pick.CreateZone](ig_pick_CreateZone.md)

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
