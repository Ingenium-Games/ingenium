# ig.callback.UnregisterClient

## Description

Register a client callback handler

## Signature

```lua
function ig.callback.UnregisterClient(eventData)
```

## Parameters

- **`eventName`**: string The name of the callback event
- **`handler`**: function The function to handle the callback
- **`eventData`**: any The event data returned from RegisterServer
- **`eventData`**: any The event data returned from RegisterClient

## Example

```lua
-- Example usage of ig.callback.UnregisterClient
local result = ig.callback.UnregisterClient(eventData)
```

## Important Notes

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.callback.Async](ig_callback_Async.md)
- [ig.callback.AsyncClient](ig_callback_AsyncClient.md)
- [ig.callback.AsyncWithTimeout](ig_callback_AsyncWithTimeout.md)
- [ig.callback.Await](ig_callback_Await.md)
- [ig.callback.AwaitClient](ig_callback_AwaitClient.md)

## Source

Defined in: `client/_callback.lua`
