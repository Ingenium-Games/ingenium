# ig.func.CreatePed

## Description

Creates a new ped instance

## Signature

```lua
function ig.func.CreatePed(name, x, y, z, h)
```

## Parameters

- **`name`**: string
- **`x`**: any
- **`y`**: any
- **`z`**: any
- **`h`**: any

## Example

```lua
-- Create new ped
local created = ig.func.CreatePed("name_example", value, value, value, value)
if created then
    print("Created successfully")
end
```

## Source

Defined in: `client/_functions.lua`
