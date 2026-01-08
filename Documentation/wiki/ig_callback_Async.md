# ig.callback.Async

## Description

local data = ig.callback.AwaitWithTimeout('Server:SlowOperation', 5, function(state)

## Signature

```lua
function ig.callback.Async(eventName, callback, ...)
```

## Parameters

- **`eventName`**: string The name of the server callback
- **`callback`**: function Function to handle the response
- **`...`**: any Additional arguments

## Example

```lua
-- Example usage of ig.callback.Async
local result = ig.callback.Async(eventName, callback, ...)
```

## Important Notes

> 📋 **Parameter**: `callback` - Function to execute upon completion

## Related Functions

- [ig.callback.AsyncClient](ig_callback_AsyncClient.md)
- [ig.callback.AsyncWithTimeout](ig_callback_AsyncWithTimeout.md)
- [ig.callback.Await](ig_callback_Await.md)
- [ig.callback.AwaitClient](ig_callback_AwaitClient.md)
- [ig.callback.AwaitWithTimeout](ig_callback_AwaitWithTimeout.md)

## Source

Defined in: `client/_callback.lua`
