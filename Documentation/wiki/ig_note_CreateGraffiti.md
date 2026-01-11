# ig.note.CreateGraffiti

## Description

Creates a new graffiti instance

## Signature

```lua
function ig.note.CreateGraffiti(coords, message, author)
```

## Parameters

- **`coords`**: any
- **`message`**: string
- **`author`**: any

## Example

```lua
-- Create new graffiti
local created = ig.note.CreateGraffiti(value, "message", value)
if created then
    print("Created successfully")
end
```

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
