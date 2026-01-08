# ig.note.CreateGraffiti

## Description

Sort by age (newest first)

## Signature

```lua
function ig.note.CreateGraffiti(coords, message, author)
```

## Parameters

- **`coords`**: table Coordinates
- **`title`**: string Note title
- **`content`**: string Note content
- **`author`**: string Author name
- **`coords`**: table Coordinates
- **`message`**: string Graffiti message
- **`author`**: string|nil Author (can be anonymous)

## Example

```lua
-- Example usage of ig.note.CreateGraffiti
local entity = ig.note.CreateGraffiti(params)
```

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.Create](ig_note_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
