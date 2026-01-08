# ig.callback.RegisterServer

## Description

ig.callback.AsyncClient('Client:UI:GetState', function(state)

## Signature

```lua
function ig.callback.RegisterServer(eventName, handler)
```

## Parameters

- **`eventName`**: string The name of the callback event
- **`handler`**: function The function to handle the callback (receives source, ...)

## Example

```lua
-- Example usage of ig.callback.RegisterServer
ig.callback.RegisterServer("eventName", function(data)
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
