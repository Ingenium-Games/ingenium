# ig.vehicle.GetByName

## Description

Retrieves and returns byname data

## Signature

```lua
function ig.vehicle.GetByName(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get byname data
local result = ig.vehicle.GetByName("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_vehicle.lua`
