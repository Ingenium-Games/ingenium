# ig.callback.RegisterServer

## Description

Registers a server callback handler. This is a convenience wrapper for RegisterServerCallback that can only be used on the server side. Returns an event handler reference that can be used to unregister the callback later.

## Signature

```lua
function ig.callback.RegisterServer(eventName, handler)
```

## Parameters

- **`eventName`**: string - The name of the callback event
- **`handler`**: function - The function to handle the callback (receives source, ...)

## Returns

- **`eventData`**: any - Event handler reference for unregistering

## Example

```lua
-- Register a server callback
local eventData = ig.callback.RegisterServer('myCustomEvent', function(source, data)
    print('Received callback from player:', source)
    print('Data:', data)
    return true
end)

-- Later, unregister the callback
ig.callback.UnregisterServer(eventData)
```

## Source

Defined in: `server/_callback.lua`
