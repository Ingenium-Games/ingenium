# ig.note.GetByAuthor

## Description

Retrieves and returns byauthor data

## Signature

```lua
function ig.note.GetByAuthor(author)
```

## Parameters

- **`author`**: any

## Example

```lua
-- Get byauthor data
local result = ig.note.GetByAuthor(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
