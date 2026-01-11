# ig.tattoo.GetAll

## Description

Performs getall operation

## Signature

```lua
function ig.tattoo.GetAll()
```

## Parameters

- **`callback`**: function

## Example

```lua
-- Get all data
local result = ig.tattoo.GetAll(function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Data]/_game_data_helpers.lua`
