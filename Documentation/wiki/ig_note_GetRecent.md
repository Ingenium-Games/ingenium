# ig.note.GetRecent

## Description

Retrieves and returns recent data

## Signature

```lua
function ig.note.GetRecent(maxAge)
```

## Parameters

- **`maxAge`**: any

## Example

```lua
-- Get recent data
local result = ig.note.GetRecent(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
