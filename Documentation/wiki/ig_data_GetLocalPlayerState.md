# ig.data.GetLocalPlayerState

## Description

Sets the client as receieved the character data. Boolean

## Signature

```lua
function ig.data.GetLocalPlayerState(key)
```

## Parameters

- **`key`**: any

## Example

```lua
-- Get localplayerstate data
local result = ig.data.GetLocalPlayerState(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_data.lua`
