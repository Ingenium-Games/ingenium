# ig.callback.AsyncWithTimeout

## Description

if player then

## Signature

```lua
function ig.callback.AsyncWithTimeout(eventName, timeout, callback, timeoutCallback, ...)
```

## Parameters

- **`eventName`**: string The name of the server callback
- **`timeout`**: number Timeout in seconds
- **`callback`**: function Function to handle the response
- **`timeoutCallback`**: function Function to call on timeout
- **`...`**: any Additional arguments

## Example

```lua
-- Example usage of ig.callback.AsyncWithTimeout
local result = ig.callback.AsyncWithTimeout(eventName, timeout, callback, timeoutCallback, ...)
```

## Important Notes

> 📋 **Parameter**: `timeout` - Sets maximum wait time for operation

> 📋 **Parameter**: `callback` - Function to execute upon completion

## Related Functions

- [ig.callback.Async](ig_callback_Async.md)
- [ig.callback.AsyncClient](ig_callback_AsyncClient.md)
- [ig.callback.Await](ig_callback_Await.md)
- [ig.callback.AwaitClient](ig_callback_AwaitClient.md)
- [ig.callback.AwaitWithTimeout](ig_callback_AwaitWithTimeout.md)

## Source

Defined in: `client/_callback.lua`
