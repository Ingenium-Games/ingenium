# ig.vehicle.GetByManufacturer

## Description

Retrieves and returns bymanufacturer data

## Signature

```lua
function ig.vehicle.GetByManufacturer(manufacturer)
```

## Parameters

- **`manufacturer`**: any

## Example

```lua
-- Get bymanufacturer data
local result = ig.vehicle.GetByManufacturer(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_vehicle.lua`
