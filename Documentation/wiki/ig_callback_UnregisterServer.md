# ig.callback.UnregisterServer

## Description

Unregisters a server callback that was previously registered with `ig.callback.RegisterServer`. This removes the callback handler and cleans up the event registration.

## Signature

```lua
function ig.callback.UnregisterServer(eventData)
```

## Parameters

- **`eventData`**: table|any - The event data returned from `RegisterServer`

## Example

```lua
-- Register a server callback
local eventData = ig.callback.RegisterServer('myCustomEvent', function(source, data)
    print('Handling event')
    return true
end)

-- Later, unregister the callback when no longer needed
ig.callback.UnregisterServer(eventData)
```

## Source

Defined in: `server/_callback.lua`
