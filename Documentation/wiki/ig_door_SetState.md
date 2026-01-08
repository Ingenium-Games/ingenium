# ig.door.SetState

## Description

Sets the state of a door (locked, unlocked, or open). State values: 0 = unlocked, 1 = locked, 2 = open.

## Signature

```lua
function ig.door.SetState(hash, state)
```

## Parameters

- **`coords`**: any
- **`coords`**: any
- **`coords`**: any

## Example

```lua
-- Example 1: Lock a door
local doorHash = GetHashKey("v_ilev_ph_door01")
ig.door.SetState(doorHash, 1)  -- 1 = locked

-- Example 2: Unlock a door
ig.door.SetState(doorHash, 0)  -- 0 = unlocked

-- Example 3: Toggle door state
ig.door.ToggleLock(doorHash)

-- Example 4: Open door without changing lock state
ig.door.SetState(doorHash, 2)  -- 2 = open but not locked
```

## Related Functions

- [ig.door.Add](ig_door_Add.md)
- [ig.door.AddDoorsToSystem](ig_door_AddDoorsToSystem.md)
- [ig.door.Find](ig_door_Find.md)
- [ig.door.FindHash](ig_door_FindHash.md)
- [ig.door.GenerateDoorsInRadius](ig_door_GenerateDoorsInRadius.md)

## Source

Defined in: `server/[Doors]/_doors.lua`
