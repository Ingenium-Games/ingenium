# ig.note.CreateBulletin

## Description

Creates a new bulletin instance

## Signature

```lua
function ig.note.CreateBulletin(coords, title, content, author)
```

## Parameters

- **`coords`**: any
- **`title`**: any
- **`content`**: any
- **`author`**: any

## Example

```lua
-- Create new bulletin
local created = ig.note.CreateBulletin(value, value, value, value)
if created then
    print("Created successfully")
end
```

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
