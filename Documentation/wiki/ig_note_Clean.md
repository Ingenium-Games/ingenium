# ig.note.Clean

## Description

This function name appears to be an alias or unused. Use ig.note.CleanOld() instead to remove old notes based on age.

## Signature

```lua
function ig.note.Clean()
```

## Parameters

- **`data`**: any
- **`id`**: any

## Example

```lua
-- Note: Use ig.note.CleanOld() instead
-- Clean notes older than default configured time
local removed = ig.note.CleanOld()

-- Clean notes older than 1 hour (3600 seconds)
local removed = ig.note.CleanOld(3600)
```

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.Create](ig_note_Create.md)
- [ig.note.CreateBulletin](ig_note_CreateBulletin.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
