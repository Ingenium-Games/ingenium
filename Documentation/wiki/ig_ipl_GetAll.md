# ig.ipl.GetAll

## Description

Set up zone in/out callbacks for IPL loading/unloading

## Signature

```lua
function ig.ipl.GetAll()
```

## Parameters

*No parameters*

## Example

```lua
-- Get all data
local result = ig.ipl.GetAll()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_ipls.lua`
