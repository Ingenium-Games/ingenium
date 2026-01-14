# UnregisterServerCallback

## Description

Unregister a previously registered server-side callback handler. Use the event data returned from `RegisterServerCallback` to identify which callback to unregister.

## Signature

```lua
UnregisterServerCallback(eventData)
```

## Parameters

- **`eventData`** (any): The event data returned from `RegisterServerCallback`

## Example

```lua
-- Server-side: Register a callback
local myCallback = RegisterServerCallback({
    eventName = "Server:GetStatus",
    eventCallback = function(source)
        return {status = "online"}
    end
})

-- Later, unregister it
UnregisterServerCallback(myCallback)
```

## Notes

- Must use the exact event data returned from the corresponding `RegisterServerCallback`
- After unregistering, client calls to that callback will fail or timeout
- Safe to call even if the callback is already unregistered

## Source

Defined in: `shared/[Third Party]/_callbacks.lua` | Exported in: `shared/_ig.lua`
