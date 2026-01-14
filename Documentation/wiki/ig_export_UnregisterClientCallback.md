# UnregisterClientCallback

## Description

Unregister a previously registered client-side callback handler. Use the event data returned from `RegisterClientCallback` to identify which callback to unregister.

## Signature

```lua
UnregisterClientCallback(eventData)
```

## Parameters

- **`eventData`** (any): The event data returned from `RegisterClientCallback`

## Example

```lua
-- Register a callback
local myCallback = RegisterClientCallback({
    eventName = "Client:MyEvent",
    eventCallback = function(data)
        return {status = "handled"}
    end
})

-- Later, unregister it
UnregisterClientCallback(myCallback)
```

## Notes

- Must use the exact event data returned from the corresponding `RegisterClientCallback`
- After unregistering, triggers to that callback will no longer call the handler
- Safe to call even if the callback is already unregistered

## Source

Defined in: `shared/[Third Party]/_callbacks.lua` | Exported in: `shared/_ig.lua`
