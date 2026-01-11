# ig.data.GetLoadedStatus

## Description

Returns the local from the local variable. String

## Signature

```lua
function ig.data.GetLoadedStatus()
```

## Parameters

*No parameters*

## Example

```lua
-- Get loadedstatus data
local result = ig.data.GetLoadedStatus()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_data.lua`
