# ig.sql.veh.GetID

## Description

Takes Vehicle information from the Database and imports it into the Server Upon the Initialise() function.

## Signature

```lua
function ig.sql.veh.GetID(Plate, cb)
```

## Parameters

- **`Plate`**: any
- **`cb`**: function

## Example

```lua
-- Get id data
local result = ig.sql.veh.GetID(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_vehicles.lua`
