# ig.gsr.GetRecent

## Description

Retrieves and returns recent data

## Signature

```lua
function ig.gsr.GetRecent(maxAge)
```

## Parameters

- **`maxAge`**: any

## Example

```lua
-- Get recent data
local result = ig.gsr.GetRecent(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_gsr.lua`
