# ig.gsr.GetCount

## Description

Clear GSR from character (washing hands, gloves)

## Signature

```lua
function ig.gsr.GetCount()
```

## Parameters

*No parameters*

## Example

```lua
-- Get count data
local result = ig.gsr.GetCount()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_gsr.lua`
