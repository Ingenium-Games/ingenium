# ig.data.GetPlayer

## Description

Retrieves and returns player data

## Signature

```lua
function ig.data.GetPlayer(id)
```

## Parameters

- **`id`**: number

## Example

```lua
-- Get player data
local result = ig.data.GetPlayer(123)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_data.lua`
