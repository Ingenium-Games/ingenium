# ig.note.GetRecent

## Description

Get most read notes

## Signature

```lua
function ig.note.GetRecent(maxAge)
```

## Parameters

- **`limit`**: number|nil Number of results (default 10)
- **`maxAge`**: number|nil Max age in seconds (default 3600 = 1 hour)

## Example

```lua
-- Example usage of ig.note.GetRecent
local result = ig.note.GetRecent()
```

## Related Functions

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.Create](ig_note_Create.md)

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
