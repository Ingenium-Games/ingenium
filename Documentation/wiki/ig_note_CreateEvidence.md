# ig.note.CreateEvidence

## Description

Create graffiti note (shorter, more casual)

## Signature

```lua
function ig.note.CreateEvidence(coords, evidence, officer, caseId)
```

## Parameters

- **`content`**: string Note content
- **`author`**: string Author name
- **`coords`**: table Coordinates
- **`message`**: string Graffiti message
- **`author`**: string|nil Author (can be anonymous)
- **`coords`**: table Coordinates
- **`evidence`**: string Evidence description
- **`officer`**: string Officer name
- **`caseId`**: string|nil Case ID

## Example

```lua
-- Example usage of ig.note.CreateEvidence
local entity = ig.note.CreateEvidence(params)
```

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.Create](ig_note_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
