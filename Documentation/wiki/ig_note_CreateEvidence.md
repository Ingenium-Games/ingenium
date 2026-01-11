# ig.note.CreateEvidence

## Description

Create graffiti note (shorter, more casual)

## Signature

```lua
function ig.note.CreateEvidence(coords, evidence, officer, caseId)
```

## Parameters

- **`coords`**: any
- **`evidence`**: any
- **`officer`**: any
- **`caseId`**: any

## Example

```lua
-- Create new evidence
local created = ig.note.CreateEvidence(value, value, value, value)
if created then
    print("Created successfully")
end
```

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
