# ig.note.GetByType

## Description

Create evidence note (police/forensics)

## Signature

```lua
function ig.note.GetByType(noteType)
```

## Parameters

- **`noteType`**: any

## Example

```lua
-- Get bytype data
local result = ig.note.GetByType(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
