# ig.note.GetByType

## Description

Create evidence note (police/forensics)

## Signature

```lua
function ig.note.GetByType(noteType)
```

## Parameters

- **`coords`**: table Coordinates
- **`message`**: string Graffiti message
- **`author`**: string|nil Author (can be anonymous)
- **`coords`**: table Coordinates
- **`evidence`**: string Evidence description
- **`officer`**: string Officer name
- **`caseId`**: string|nil Case ID
- **`noteType`**: string Type (bulletin, graffiti, evidence, etc.)

## Example

```lua
-- Example usage of ig.note.GetByType
local result = ig.note.GetByType()
```

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.Create](ig_note_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
