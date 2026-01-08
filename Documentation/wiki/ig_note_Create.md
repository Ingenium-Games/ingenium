# ig.note.Create

## Description

====================================================================================--

## Signature

```lua
function ig.note.Create(coords, note, author, event, data)
```

## Parameters

- **`coords`**: table Coordinates {x, y, z, h}
- **`note`**: string Note text content
- **`author`**: string|nil Author name/ID
- **`event`**: string|nil Event to trigger on read
- **`data`**: table|nil Additional data

## Example

```lua
-- Example usage of ig.note.Create
local entity = ig.note.Create(params)
```

## Important Notes

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.CreateBulletin](ig_note_CreateBulletin.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
