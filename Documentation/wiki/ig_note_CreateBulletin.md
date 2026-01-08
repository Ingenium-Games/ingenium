# ig.note.CreateBulletin

## Description

Get recent notes

## Signature

```lua
function ig.note.CreateBulletin(coords, title, content, author)
```

## Parameters

- **`maxAge`**: number|nil Max age in seconds (default 3600 = 1 hour)
- **`coords`**: table Coordinates
- **`title`**: string Note title
- **`content`**: string Note content
- **`author`**: string Author name

## Example

```lua
-- Example usage of ig.note.CreateBulletin
local entity = ig.note.CreateBulletin(params)
```

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.Create](ig_note_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
