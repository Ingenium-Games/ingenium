# ig.ipl.Get

## Description

Only load IPLs, don't trigger zone setup again

## Signature

```lua
function ig.ipl.Get(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get  data
local result = ig.ipl.Get("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_ipls.lua`
