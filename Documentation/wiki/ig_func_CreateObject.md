# ig.func.CreateObject

## Description

Creates a new object instance

## Signature

```lua
function ig.func.CreateObject(model, x, y, z, isdoor, data)
```

## Parameters

- **`name`**: string
- **`x`**: any
- **`y`**: any
- **`z`**: any
- **`isdoor`**: any

## Example

```lua
-- Create new object
local created = ig.func.CreateObject("name_example", value, value, value, value)
if created then
    print("Created successfully")
end
```

## Source

Defined in: `client/_functions.lua`
