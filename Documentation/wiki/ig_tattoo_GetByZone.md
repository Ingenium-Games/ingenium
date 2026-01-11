# ig.tattoo.GetByZone

## Description

Performs getbyzone operation

## Signature

```lua
function ig.tattoo.GetByZone(zone)
```

## Parameters

- **`zone`**: any
- **`callback`**: function

## Example

```lua
-- Get byzone data
local result = ig.tattoo.GetByZone(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Data]/_game_data_helpers.lua`
