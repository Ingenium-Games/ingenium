# ig.data.GetPlayerState

## Description

Please do not use this other than for animations or such...

## Signature

```lua
function ig.data.GetPlayerState(id, key)
```

## Parameters

- **`id`**: number
- **`key`**: any

## Example

```lua
-- Get playerstate data
local result = ig.data.GetPlayerState(123, value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_data.lua`
