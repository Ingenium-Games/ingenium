# ig.vehicle.GetCurrentSeat

## Description

Retrieves and returns currentseat data

## Signature

```lua
function ig.vehicle.GetCurrentSeat()
```

## Parameters

*No parameters*

## Example

```lua
-- Get currentseat data
local result = ig.vehicle.GetCurrentSeat()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_vehicle.lua`
