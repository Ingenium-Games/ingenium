# ig.callback.AsyncClient

## Description

====================================================================================--

## Signature

```lua
function ig.callback.AsyncClient(eventName, callback, ...)
```

## Parameters

- **`eventName`**: string The name of the client callback to trigger
- **`...`**: any Additional arguments to pass to the callback
- **`eventName`**: string The name of the client callback
- **`callback`**: function Function to handle the response
- **`...`**: any Additional arguments

## Example

```lua
-- Example usage of ig.callback.AsyncClient
local result = ig.callback.AsyncClient(eventName, callback, ...)
```

## Important Notes

> 📋 **Parameter**: `callback` - Function to execute upon completion

## Related Functions

- [ig.callback.Async](ig_callback_Async.md)
- [ig.callback.AsyncWithTimeout](ig_callback_AsyncWithTimeout.md)
- [ig.callback.Await](ig_callback_Await.md)
- [ig.callback.AwaitClient](ig_callback_AwaitClient.md)
- [ig.callback.AwaitWithTimeout](ig_callback_AwaitWithTimeout.md)

## Source

Defined in: `client/_callback.lua`
