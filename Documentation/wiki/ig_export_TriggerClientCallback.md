# TriggerClientCallback

## Description

Trigger a local client callback (not networked). Used to call registered client-side callbacks from within the client context.

## Signature

```lua
TriggerClientCallback({
    eventName = string,
    args = table (optional),
    timeout = number (optional, in seconds),
    timedout = function (optional, called on timeout),
    callback = function (optional, for async response)
})
```

## Parameters

- **`eventName`** (string): The name of the callback event to trigger
- **`args`** (table, optional): Arguments to pass to the callback handler
- **`timeout`** (number, optional): Timeout in seconds (for awaiting response)
- **`timedout`** (function, optional): Function called if timeout is reached
- **`callback`** (function, optional): Async response handler (if not provided, call is synchronous)

## Returns

- **`any`**: The result from the callback handler (if synchronous)

## Example

```lua
-- Synchronous call
local result = TriggerClientCallback({
    eventName = "Client:UI:GetState"
})

-- Asynchronous call with response handler
TriggerClientCallback({
    eventName = "Client:UI:GetState",
    callback = function(state)
        print("UI State:", json.encode(state))
    end
})

-- With timeout
local result = TriggerClientCallback({
    eventName = "Client:UI:GetState",
    timeout = 5,
    timedout = function(state)
        print("Callback timed out, state:", state)
    end
})
```

## Notes

- This is a **local-only callback**, not networked
- Use `TriggerServerCallback` for server communication
- Best used with `ig.callback.AwaitClient()` or `ig.callback.AsyncClient()` wrappers
- Requires `RegisterClientCallback` to have a registered handler

## Source

Defined in: `shared/[Third Party]/_callbacks.lua` | Exported in: `shared/_ig.lua`
