# ig.vehicle.GetByHash

## Description

Retrieves and returns byhash data

## Signature

```lua
function ig.vehicle.GetByHash(hash)
```

## Parameters

- **`hash`**: number
- **`callback`**: function

## Example

```lua
-- Get byhash data
local result = ig.vehicle.GetByHash(100, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Data]/_game_data_helpers.lua`
