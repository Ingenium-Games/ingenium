# ig.pick.CreateZone

## Description

Handle loot pickup

## Signature

```lua
function ig.pick.CreateZone(center, radius, count, models, data)
```

## Parameters

- **`center`**: table Center coordinates
- **`radius`**: number Spawn radius
- **`count`**: number Number of pickups to create
- **`models`**: table Array of model hashes
- **`data`**: table Pickup data

## Example

```lua
-- Example usage of ig.pick.CreateZone
local entity = ig.pick.CreateZone(params)
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
