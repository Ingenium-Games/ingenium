# Callback System Wrapper - Implementation Guide

## Overview

This document describes the `ig.callback` namespace wrapper that provides convenient access to the Ingenium callback system for client-side scripts.

## Background

The Ingenium framework uses a sophisticated callback system (implemented in `shared/[Third Party]/_callbacks.lua`) that provides secure, promise-based client-server communication. However, the global functions were not wrapped in the `ig` namespace, leading to:

1. Inconsistent API usage across the codebase
2. AI-generated code attempting to use non-existent `ig.callback.Await()`
3. Confusion between synchronous and asynchronous callback patterns

## Solution

The `client/_callback.lua` file provides a wrapper namespace `ig.callback` that:
- ✅ Provides convenient methods matching the `ig` namespace convention
- ✅ Maintains compatibility with the underlying callback system
- ✅ Clearly distinguishes synchronous (Await) vs asynchronous (Async) patterns
- ✅ Adds utility functions for common callback operations

## API Reference

### Synchronous Server Callbacks

#### `ig.callback.Await(eventName, ...)`

Triggers a server callback and **waits** for the response (blocking).

```lua
-- Simple usage
local data = ig.callback.Await('Server:GetData')

-- With arguments
local player = ig.callback.Await('Server:GetPlayer', playerId)

-- Multiple arguments
local result = ig.callback.Await('Server:DoSomething', arg1, arg2, arg3)
```

**When to use:**
- When you need the result immediately to continue execution
- In initialization code where blocking is acceptable
- When the callback is expected to be fast

**Example from codebase:**
```lua
-- client/_appearance.lua
appearanceConstants = ig.callback.Await('ig:GameData:GetAppearanceConstants')
```

---

### Asynchronous Server Callbacks

#### `ig.callback.Async(eventName, callback, ...)`

Triggers a server callback and handles the response via a callback function (non-blocking).

```lua
-- Simple usage
ig.callback.Async('Server:GetData', function(data)
    print('Received:', json.encode(data))
end)

-- With arguments
ig.callback.Async('Server:GetPlayer', function(player)
    if player then
        print('Player name:', player.name)
    end
end, playerId)
```

**When to use:**
- When you don't need the result immediately
- To avoid blocking the main thread
- For operations that might take longer
- When you want to process the result in a callback

**Example from codebase:**
```lua
-- client/[Data]/_game_data_helpers.lua
ig.callback.Async('ig:GameData:GetTattoos', function(data)
    tattooCache = data
    callback(data)
end)
```

---

### Timeout Support

#### `ig.callback.AwaitWithTimeout(eventName, timeout, timeoutCallback, ...)`

Synchronous callback with timeout handling.

```lua
local data = ig.callback.AwaitWithTimeout('Server:SlowOperation', 5, function(state)
    print('Request timed out with state: ' .. state)
end, someArg)
```

#### `ig.callback.AsyncWithTimeout(eventName, timeout, callback, timeoutCallback, ...)`

Asynchronous callback with timeout handling.

```lua
ig.callback.AsyncWithTimeout('Server:SlowOperation', 5, 
    function(result)
        print('Success:', json.encode(result))
    end,
    function(state)
        print('Timed out with state:', state)
    end,
    someArg
)
```

---

### Client-to-Client Callbacks

#### `ig.callback.AwaitClient(eventName, ...)`

Trigger a local client callback synchronously.

```lua
local uiState = ig.callback.AwaitClient('Client:UI:GetState')
```

#### `ig.callback.AsyncClient(eventName, callback, ...)`

Trigger a local client callback asynchronously.

```lua
ig.callback.AsyncClient('Client:UI:GetState', function(state)
    print('UI State:', json.encode(state))
end)
```

---

### Registration Helpers

#### `ig.callback.RegisterClient(eventName, handler)`

Register a client-side callback handler (convenience wrapper).

```lua
local eventData = ig.callback.RegisterClient('MyCallback', function(arg1, arg2)
    return {success = true, data = someData}
end)
```

#### `ig.callback.UnregisterClient(eventData)`

Unregister a client callback.

```lua
ig.callback.UnregisterClient(eventData)
```

---

## Pattern Comparison

### ❌ INCORRECT - Mixed Pattern

```lua
-- DON'T: Using Await with a callback function
ig.callback.Await('Server:GetData', function(data)
    print(data) -- This won't work as expected
end)
```

### ✅ CORRECT - Synchronous Pattern

```lua
-- DO: Use Await without callback, capture return value
local data = ig.callback.Await('Server:GetData')
print(data)
```

### ✅ CORRECT - Asynchronous Pattern

```lua
-- DO: Use Async with callback function
ig.callback.Async('Server:GetData', function(data)
    print(data)
end)
```

---

## Migration Guide

### From Direct `TriggerServerCallback`

**Before:**
```lua
local data = TriggerServerCallback({
    eventName = 'Server:GetData',
    args = {arg1, arg2}
})
```

**After:**
```lua
local data = ig.callback.Await('Server:GetData', arg1, arg2)
```

### From Incorrect `ig.callback.Await` with Callback

**Before:**
```lua
ig.callback.Await('Server:GetData', function(data)
    processData(data)
end, someArg)
```

**After:**
```lua
ig.callback.Async('Server:GetData', function(data)
    processData(data)
end, someArg)
```

---

## Performance Considerations

### Synchronous (Await) Callbacks
- **Pros:** Simple to understand, clean code flow
- **Cons:** Blocks execution until response received
- **Use when:** Fast operations, initialization, required data

### Asynchronous (Async) Callbacks
- **Pros:** Non-blocking, better for slow operations
- **Cons:** Slightly more complex callback nesting
- **Use when:** Slow operations, optional data, parallel requests

---

## Security Notes

The underlying callback system includes:
- ✅ Cryptographically secure tickets (configurable length)
- ✅ Rate limiting per player (configurable)
- ✅ Ticket expiration (30 seconds default)
- ✅ Source validation
- ✅ One-time use tickets

These security features are automatically handled by the wrapper.

---

## Common Patterns

### Caching Pattern

```lua
local cache = nil

function GetData(callback)
    if cache then
        callback(cache)
    else
        ig.callback.Async('Server:GetData', function(data)
            cache = data
            callback(data)
        end)
    end
end
```

### Parallel Requests

```lua
-- Don't block on each one
ig.callback.Async('Server:GetData1', function(data1)
    -- Process data1
end)

ig.callback.Async('Server:GetData2', function(data2)
    -- Process data2
end)
```

### Sequential Dependencies

```lua
-- When you need data from one to request another
ig.callback.Async('Server:GetUser', function(user)
    if user then
        ig.callback.Async('Server:GetUserItems', function(items)
            -- Process items
        end, user.id)
    end
end, userId)
```

---

## Testing

To verify the implementation:

```lua
-- Test synchronous
RegisterCommand('test_await', function()
    local result = ig.callback.Await('TestCallback', 'arg1')
    print('Sync result:', json.encode(result))
end)

-- Test asynchronous
RegisterCommand('test_async', function()
    ig.callback.Async('TestCallback', function(result)
        print('Async result:', json.encode(result))
    end, 'arg1')
end)
```

---

## Files Modified

1. **Created:** `client/_callback.lua` - Wrapper implementation
2. **Modified:** `fxmanifest.lua` - Added callback wrapper to client_scripts load order
3. **Fixed:** `client/[Data]/_game_data_helpers.lua` - Corrected Await→Async pattern
4. **Created:** `ISSUE_CALLBACK_AWAIT.md` - Issue documentation
5. **Created:** This file - Implementation guide

---

## Troubleshooting

### "attempt to call a nil value (field 'Await')"

**Cause:** `client/_callback.lua` not loaded before the file using it.

**Fix:** Verify `fxmanifest.lua` loads `client/_callback.lua` early in client_scripts.

### Callback never returns / times out

**Cause:** Server callback not registered or wrong event name.

**Fix:** Verify the server has `RegisterServerCallback` for that event name.

### "ig.callback.Await expected return value but got nil"

**Cause:** Using Await but the server callback doesn't return a value.

**Fix:** Either make server callback return a value, or use Async pattern instead.

---

## Further Reading

- [Callbacks.md](Documentation/Callbacks.md) - Main callback system documentation
- `shared/[Third Party]/_callbacks.lua` - Core implementation
- `client/_callback.lua` - Wrapper source code

---

**Version:** 1.0  
**Date:** 2026-01-03  
**Author:** Ingenium Framework
