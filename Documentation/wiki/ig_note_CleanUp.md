# ig.note.CleanUp

## Description

Legacy function name. Use ig.note.CleanOld() to remove old notes from the system based on age threshold.

## Signature

```lua
function ig.note.CleanUp()
```

## Parameters

- **`id`**: any

## Example

```lua
-- Clean old notes from system
local removed = ig.note.CleanOld()
print("Removed " .. removed .. " old notes")
```

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.Create](ig_note_Create.md)
- [ig.note.CreateBulletin](ig_note_CreateBulletin.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
