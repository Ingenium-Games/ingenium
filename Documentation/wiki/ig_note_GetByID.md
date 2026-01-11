# ig.note.GetByID

## Description

Retrieves and returns byid data

## Signature

```lua
function ig.note.GetByID(id)
```

## Parameters

- **`id`**: number

## Example

```lua
-- Get byid data
local result = ig.note.GetByID(123)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_notes.lua`
