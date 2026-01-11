# ig.weapon.GetAll

## Description

Retrieves and returns all data

## Signature

```lua
function ig.weapon.GetAll()
```

## Parameters

- **`callback`**: function

## Example

```lua
-- Get all data
local result = ig.weapon.GetAll(function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Data]/_game_data_helpers.lua`
