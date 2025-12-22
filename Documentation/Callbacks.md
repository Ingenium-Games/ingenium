# Ingenium Framework – Callback System

This documentation covers the callback system implemented in the Ingenium framework, with a focus on the primary implementation in [`ingenium/shared/[Third Party]/_callbacks.lua`](https://github.com/Ingenium-Games/ingenium/blob/main/shared/%5BThird%20Party%5D/_callbacks.lua).

---

## Overview

Ingenium uses an advanced callback system to enable asynchronous, secure, and permission-aware interactions between client and server. This allows Lua, JavaScript (NUI), and Vue modules to communicate in a robust, scalable fashion, greatly enhancing flexibility for FiveM resource development.

The system includes:
- Server callbacks (register, trigger, unregister)
- Client callbacks (register, trigger)
- Support for promises, timeouts, async/sync usage
- Security: event tickets & rate limiting
- Optional ACL (permission) checks

---

## Callback System API

**Main file:**  
[`shared/[Third Party]/_callbacks.lua`](https://github.com/Ingenium-Games/ingenium/blob/main/shared/%5BThird%20Party%5D/_callbacks.lua)

### 1. Server Callbacks

#### RegisterServerCallback

Registers a handler for a named server event.
```lua
_G.RegisterServerCallback = function(args)
  -- args: { eventName, eventCallback }
end
```
**Parameters:**
- `eventName` (string): Name of the event to handle
- `eventCallback` (function): Function to execute when the event is triggered

Usage:
```lua
RegisterServerCallback({
    eventName = "SomeEvent",
    eventCallback = function(source, payload)
        -- Handle event, return result (sync or async)
    end
})
```

#### UnregisterServerCallback

Removes a previously registered callback.
```lua
_G.UnregisterServerCallback = function(eventData)
  RemoveEventHandler(eventData)
end
```

#### TriggerServerCallback

Triggers a server-side callback for a player, optionally with timeout and async handling.
```lua
_G.TriggerServerCallback = function(args)
  -- args: {
  --   source,                -- player id
  --   eventName,             -- string
  --   args,                  -- table (arguments)
  --   timeout,               -- optional, number (in seconds)
  --   timedout,              -- optional, function
  --   callback               -- optional, async result handler
  -- }
end
```
- If `callback` is omitted, returns a promise for synchronous await (see: `Citizen.Await`).
- Timeout logic triggers `timedout` if set.

---

### 2. Client Callbacks

#### RegisterClientCallback

Registers a handler for a client-side event.
```lua
_G.RegisterClientCallback = function(args)
  -- args: { eventName, eventCallback }
end
```
- `eventCallback` (function): Function to execute with unpacked event arguments

#### TriggerClientCallback

Triggers a client-side callback event.
```lua
_G.TriggerClientCallback = function(args)
  -- args: {
  --   eventName,  -- string
  --   args,       -- arguments
  --   timeout,    -- optional, number (seconds)
  --   timedout,   -- optional, function to call on timeout
  --   callback    -- optional, function to handle result (async)
  -- }
end
```

---

### 3. Internal Mechanisms

#### Promises (Async Handling)

The callback system makes heavy use of custom `promise` objects, allowing asynchronous code with optional timeouts. If a callback doesn't return quickly, you can specify a timeout and a handler for the case where it takes too long.

**Promise states:**
- `PENDING`, `RESOLVING`, `REJECTING`, `RESOLVED`, `REJECTED`

#### Event Tickets (Security)

- Every callback receives a cryptographically secure "ticket."
- Tickets validate that requests are legitimate.
- Expired tickets are cleaned up periodically by an internal thread.
- Ticket lifetimes, lengths, and cleanup intervals are configurable.

#### Rate Limiting

- Calls are tracked per-player (source).
- If a player exceeds `maxRequestsPerSecond`, their callback is rejected.
- Configurable via `conf.callback.*` options.

#### ACL Permissions

Sensitive callbacks can require ACE permissions:
```lua
if not IsPlayerAceAllowed(source, 'callback.eventName') then
    return nil, "Permission denied"
end
```

---

## Example – Server Callback

```lua
RegisterServerCallback({
    eventName = "GetInventory",
    eventCallback = function(source, who)
        local xPlayer = ig.data.GetPlayer(who)
        return xPlayer and xPlayer.Inventory or nil
    end
})

-- To invoke from client:
ig.callback.Await('GetInventory', function(items)
  print("Received inventory:", items)
end, "somePlayerId")
```

---

## NUI (JS/TS) Usage

On the frontend (e.g., Vue/NUI), callbacks can be triggered via HTTP POST:
```javascript
export async function callClientCallback(callback, ...args) {
  const resourceName = await GetParentResourceName();
  const response = await fetch(`https://${resourceName}/${callback}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(args)
  });
  return response.ok ? await response.json() : null;
}
```

---

## Advanced: Example Logic Flow

1. **Client calls `TriggerServerCallback`**  
   → Internal: ticket generated, rate limit checked, promise created.
2. **Server receives and validates ticket**  
   → Executes registered `eventCallback`.
3. **Response sent back to client**  
   → Promise resolved, result returned or passed to async callback.

---

## Further Reading

- Full source: [`shared/[Third Party]/_callbacks.lua`](https://github.com/Ingenium-Games/ingenium/blob/main/shared/%5BThird%20Party%5D/_callbacks.lua)
- Example usage in [`server/[Callbacks]/_dump.lua`](https://github.com/Ingenium-Games/ingenium/blob/main/server/%5BCallbacks%5D/_dump.lua)
- [NUI usage](https://github.com/Ingenium-Games/ingenium/blob/main/nui/src/utils/nui.js) for client<->frontend calls

---

## Summary

The Ingenium callback system enables secure, asynchronous communication between client, server, and browser-based UIs. By providing central registration, tickets, timeouts, and permission checks, it empowers complex and performant FiveM applications.
