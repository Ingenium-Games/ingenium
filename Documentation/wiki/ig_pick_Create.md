# ig.pick.Create

## Description

====================================================================================--

## Signature

```lua
function ig.pick.Create(coords, model, event, data)
```

## Parameters

- **`coords`**: table Coordinates {x, y, z, h}
- **`model`**: number Model hash
- **`event`**: string|nil Event to trigger on pickup
- **`data`**: table|nil Additional data

## Example

```lua
-- Example usage of ig.pick.Create
local entity = ig.pick.Create(params)
```

## Important Notes

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.pick.Activate](ig_pick_Activate.md)
- [ig.pick.CleanupOld](ig_pick_CleanupOld.md)
- [ig.pick.Collect](ig_pick_Collect.md)
- [ig.pick.CreateLoot](ig_pick_CreateLoot.md)
- [ig.pick.CreateZone](ig_pick_CreateZone.md)

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
