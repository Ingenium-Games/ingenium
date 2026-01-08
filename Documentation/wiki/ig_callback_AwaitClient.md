# ig.callback.AwaitClient

## Description

function(result)

## Signature

```lua
function ig.callback.AwaitClient(eventName, ...)
```

## Parameters

- **`eventName`**: string The name of the client callback to trigger
- **`...`**: any Additional arguments to pass to the callback

## Example

```lua
-- Example usage of ig.callback.AwaitClient
local result = ig.callback.AwaitClient("eventName", arg1, arg2)
```

## Related Functions

- [ig.callback.Async](ig_callback_Async.md)
- [ig.callback.AsyncClient](ig_callback_AsyncClient.md)
- [ig.callback.AsyncWithTimeout](ig_callback_AsyncWithTimeout.md)
- [ig.callback.Await](ig_callback_Await.md)
- [ig.callback.AwaitWithTimeout](ig_callback_AwaitWithTimeout.md)

## Source

Defined in: `client/_callback.lua`
