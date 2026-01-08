# ig.callback.RegisterClient

## Description

-- Server-side only

## Signature

```lua
function ig.callback.RegisterClient(eventName, handler)
```

## Parameters

- **`eventName`**: string The name of the callback event
- **`handler`**: function The function to handle the callback

## Example

```lua
-- Example usage of ig.callback.RegisterClient
ig.callback.RegisterClient("eventName", function(data)
    -- Handle event
end)
```

## Related Functions

- [ig.callback.Async](ig_callback_Async.md)
- [ig.callback.AsyncClient](ig_callback_AsyncClient.md)
- [ig.callback.AsyncWithTimeout](ig_callback_AsyncWithTimeout.md)
- [ig.callback.Await](ig_callback_Await.md)
- [ig.callback.AwaitClient](ig_callback_AwaitClient.md)

## Source

Defined in: `client/_callback.lua`
