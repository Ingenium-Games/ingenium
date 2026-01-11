# ig.modkit.GetByID

## Description

Retrieves and returns byid data

## Signature

```lua
function ig.modkit.GetByID(id)
```

## Parameters

- **`id`**: string

## Example

```lua
-- Get byid data
local result = ig.modkit.GetByID("id_12345")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_modkit.lua`
