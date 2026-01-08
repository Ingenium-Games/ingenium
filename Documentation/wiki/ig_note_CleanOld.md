# ig.note.CleanOld

## Description

Update note content

## Signature

```lua
function ig.note.CleanOld(maxAge)
```

## Parameters

- **`id`**: string Note ID
- **`newContent`**: string New note text
- **`editor`**: string|nil Editor name/ID
- **`maxAge`**: number|nil Max age in seconds (uses config if nil)

## Example

```lua
-- Example usage of ig.note.CleanOld
local result = ig.note.CleanOld(maxAge)
```

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.Create](ig_note_Create.md)
- [ig.note.CreateBulletin](ig_note_CreateBulletin.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
