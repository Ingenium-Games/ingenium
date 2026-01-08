# ig.callback.UnregisterServer

## Description

Register a client callback handler

## Signature

```lua
function ig.callback.UnregisterServer(eventData)
```

## Parameters

- **`eventName`**: string The name of the callback event
- **`handler`**: function The function to handle the callback
- **`eventData`**: any The event data returned from RegisterServer

## Example

```lua
-- Example usage of ig.callback.UnregisterServer
local result = ig.callback.UnregisterServer(eventData)
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
