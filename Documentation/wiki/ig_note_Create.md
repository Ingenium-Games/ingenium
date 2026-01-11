# ig.note.Create

## Description

Creates a new  instance

## Signature

```lua
function ig.note.Create(coords, note, author, event, data)
```

## Parameters

- **`coords`**: any
- **`note`**: any
- **`author`**: any
- **`event`**: any
- **`data`**: table

## Example

```lua
-- Create new 
local created = ig.note.Create(value, value, value, value, {})
if created then
    print("Created successfully")
end
```

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
