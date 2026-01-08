# ig.callback.AwaitWithTimeout

## Description

-- Simple usage

## Signature

```lua
function ig.callback.AwaitWithTimeout(eventName, timeout, timeoutCallback, ...)
```

## Parameters

- **`eventName`**: string The name of the server callback
- **`timeout`**: number Timeout in seconds
- **`timeoutCallback`**: function Function to call on timeout
- **`...`**: any Additional arguments

## Example

```lua
-- Example usage of ig.callback.AwaitWithTimeout
local result = ig.callback.AwaitWithTimeout("eventName", arg1, arg2)
```

## Important Notes

> 📋 **Parameter**: `timeout` - Sets maximum wait time for operation

> 📋 **Parameter**: `callback` - Function to execute upon completion

## Related Functions

- [ig.callback.Async](ig_callback_Async.md)
- [ig.callback.AsyncClient](ig_callback_AsyncClient.md)
- [ig.callback.AsyncWithTimeout](ig_callback_AsyncWithTimeout.md)
- [ig.callback.Await](ig_callback_Await.md)
- [ig.callback.AwaitClient](ig_callback_AwaitClient.md)

## Source

Defined in: `client/_callback.lua`
