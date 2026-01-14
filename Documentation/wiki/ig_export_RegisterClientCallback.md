# RegisterClientCallback

## Description

Register a handler for a local client-side callback event. Handlers registered with this function can be triggered using `TriggerClientCallback`.

## Signature

```lua
RegisterClientCallback({
    eventName = string,
    eventCallback = function
})
```

## Parameters

- **`eventName`** (string): The name of the callback event to register
- **`eventCallback`** (function): The handler function that will be called when the callback is triggered

## Returns

- **`any`**: Event handler reference (can be used with `UnregisterClientCallback`)

## Example

```lua
-- Register a simple callback
RegisterClientCallback({
    eventName = "Client:UI:GetState",
    eventCallback = function()
        return {
            menuOpen = false,
            inputActive = false
        }
    end
})

-- Register with arguments
RegisterClientCallback({
    eventName = "Client:Item:Use",
    eventCallback = function(itemName, itemData)
        print("Using item:", itemName)
        return {success = true}
    end
})

-- Store reference for later unregistering
local myCallback = RegisterClientCallback({
    eventName = "Client:Custom:Event",
    eventCallback = function(data)
        return processData(data)
    end
})

-- Later, unregister it
UnregisterClientCallback(myCallback)
```

## Notes

- This callback is **local-only** (not networked between clients)
- Use `RegisterServerCallback` for server-side callback handlers
- The callback function receives unpacked arguments from the caller
- Return values are sent back to the caller (if synchronous) or to the callback handler (if async)

## Source

Defined in: `shared/[Third Party]/_callbacks.lua` | Exported in: `shared/_ig.lua`
