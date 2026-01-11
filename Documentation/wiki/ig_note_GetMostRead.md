# ig.note.GetMostRead

## Description

Retrieves and returns mostread data

## Signature

```lua
function ig.note.GetMostRead(limit)
```

## Parameters

- **`limit`**: any

## Example

```lua
-- Get mostread data
local result = ig.note.GetMostRead(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
