# ig.callback.Async

## Description

local data = ig.callback.AwaitWithTimeout('Server:SlowOperation', 5, function(state)

## Signature

```lua
function ig.callback.Async(eventName, callback, ...)
```

## Parameters

- **`eventName`**: any
- **`callback`**: number
- **`...`**: any

## Example

```lua
-- Example usage
local result = ig.callback.Async(value, 100, value)
```

## Source

Defined in: `client/_callback.lua`
