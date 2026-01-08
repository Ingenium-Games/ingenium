# ig.note.ValidateData

## Description

Get notes by type

## Signature

```lua
function ig.note.ValidateData(noteData)
```

## Parameters

- **`noteType`**: string Type (bulletin, graffiti, evidence, etc.)
- **`noteData`**: table Note data to validate

## Example

```lua
-- Example usage of ig.note.ValidateData
local result = ig.note.ValidateData(noteData)
```

## Important Notes

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.Create](ig_note_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
