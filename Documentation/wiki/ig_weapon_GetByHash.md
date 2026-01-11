# ig.weapon.GetByHash

## Description

Retrieves and returns byhash data

## Signature

```lua
function ig.weapon.GetByHash(hash)
```

## Parameters

- **`hash`**: number

## Example

```lua
-- Get byhash data
local result = ig.weapon.GetByHash(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Data]/_game_data_helpers.lua`
