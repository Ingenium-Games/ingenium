# ig.pick.GetByEvent

## Description

Update pickup data

## Signature

```lua
function ig.pick.GetByEvent(eventName)
```

## Parameters

- **`uuid`**: string Pickup UUID
- **`data`**: table New data to merge
- **`eventName`**: string Event name to search for

## Example

```lua
-- Example usage of ig.pick.GetByEvent
local result = ig.pick.GetByEvent()
```

## Related Functions

- [ig.pick.Activate](ig_pick_Activate.md)
- [ig.pick.CleanupOld](ig_pick_CleanupOld.md)
- [ig.pick.Collect](ig_pick_Collect.md)
- [ig.pick.Create](ig_pick_Create.md)
- [ig.pick.CreateLoot](ig_pick_CreateLoot.md)

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
