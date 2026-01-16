# Callback System Usage Reference

## Overview

The Ingenium callback system enables secure, asynchronous communication between client and server. This document clarifies the correct usage patterns to avoid common mistakes.

---

## Quick Reference: Three Callback Methods

### 1. **Direct TriggerServerCallback (Low-Level)**

Used when you need the callback functionality directly. **ALWAYS use named `callback =` parameter**.

```lua
-- ✅ CORRECT: Named 'callback =' parameter
TriggerServerCallback({
    eventName = "GetInitializationData",
    args = {},
    callback = function(initData)
        print("Received:", json.encode(initData))
    end
})

-- ❌ WRONG: Passing callback as positional argument
TriggerServerCallback({
    eventName = "GetInitializationData",
    args = {}
}, function(initData)  -- This won't work!
    print("Never called")
end)
```

### 2. **ig.callback.Async (Recommended for Async)**

High-level wrapper that automatically uses the callback pattern. Cleaner and more readable.

```lua
-- ✅ CORRECT: Async pattern with callback function
ig.callback.Async('Server:GetData', function(data)
    print("Received:", json.encode(data))
end)

-- ✅ WITH ARGUMENTS: Pass additional parameters after callback
ig.callback.Async('Server:GetPlayer', function(player)
    print("Player:", player.name)
end, playerId)
```

### 3. **ig.callback.Await (For Synchronous)**

High-level wrapper that blocks until response arrives. Used for initialization code.

```lua
-- ✅ CORRECT: Blocking wait for response
local data = ig.callback.Await('Server:GetData')
print("Received:", json.encode(data))

-- ✅ WITH ARGUMENTS
local player = ig.callback.Await('Server:GetPlayer', playerId)
print("Player:", player.name)
```

---

## Common Mistakes & Corrections

### ❌ MISTAKE 1: Positional Callback Parameter

**Problem:** Using callback as second positional argument instead of named parameter.

```lua
-- ❌ WRONG - Callback as second positional argument
TriggerServerCallback({
    eventName = "GetInitializationData",
    args = {}
}, function(initData)
    print("This never executes")
end)
```

**Why it fails:** The callback system doesn't recognize the callback function in the positional argument. The server handler is never properly invoked.

**Solution:**
```lua
-- ✅ CORRECT - Callback as named parameter
TriggerServerCallback({
    eventName = "GetInitializationData",
    args = {},
    callback = function(initData)
        print("This works!")
    end
})

-- ✅ OR USE WRAPPER (Recommended)
ig.callback.Async('Server:GetInitializationData', function(initData)
    print("This works too!")
end)
```

---

### ❌ MISTAKE 2: Confusing Wrapper Signatures

**Problem:** Incorrect parameter order when using `ig.callback.Async()`.

```lua
-- ❌ WRONG - Callback is SECOND parameter
ig.callback.Async(function(data)
    print("Wrong position")
end, 'Server:GetData')

-- ❌ WRONG - Args after callback mixed up
ig.callback.Async('Server:GetData', playerId, function(data)
    print("Args in wrong place")
end)
```

**Correct signature:**
```lua
-- ✅ CORRECT - Event name first, then callback, then args
ig.callback.Async('Server:GetData', function(data)
    print("Event name → callback → args")
end, arg1, arg2, arg3)
```

---

### ❌ MISTAKE 3: Missing Table Wrapper

**Problem:** Not passing callback parameters as a Lua table to `TriggerServerCallback`.

```lua
-- ❌ WRONG - Multiple positional arguments
TriggerServerCallback("GetData", {}, function(data)
    print("Wrong syntax")
end)

-- ❌ WRONG - Inconsistent parameter format
TriggerServerCallback("GetData", function(data)
    print("Missing table wrapper")
end)
```

**Correct syntax:**
```lua
-- ✅ CORRECT - Everything in named table
TriggerServerCallback({
    eventName = "GetData",
    args = {},
    callback = function(data)
        print("Correct!")
    end
})
```

---

## Real-World Examples

### Example 1: Initialization (From client.lua)

```lua
-- ✅ CORRECT: Batch loading all initialization data
TriggerServerCallback({
    eventName = "GetInitializationData",
    args = {},
    callback = function(initData)
        if initData and initData.items then
            ig.item.SetItems(initData.items)
        end
        
        if initData and initData.doors then
            ig.door.SetDoors(initData.doors)
        end
        
        if initData and initData.weapons then
            ig.weapon.InitializeWeaponData(initData.weapons)
        end
    end
})
```

### Example 2: Death Handler (From _death.lua)

```lua
-- ✅ CORRECT: Character death with callback
TriggerServerCallback({
    eventName = "Server:Character:Death",
    args = {deathData},
    callback = function(result)
        if result and not result.success then
            
        end
    end
})
```

### Example 3: Using ig.callback Wrapper (Recommended)

```lua
-- ✅ CORRECT: Using high-level wrapper for cleaner code
ig.callback.Async('Server:Character:Death', function(result)
    if result and not result.success then
        
    end
end, deathData)
```

### Example 4: Synchronous Initialization

```lua
-- ✅ CORRECT: Using Await for initialization (blocks until response)
local appearanceConstants = ig.callback.Await('ig:GameData:GetAppearanceConstants')
local tattoos = ig.callback.Await('ig:GameData:GetTattoos')

-- Safe to use immediately after
print("Loaded " .. #tattoos .. " tattoo designs")
```

---

## Decision Matrix: Which Method to Use?

| Scenario | Method | Example |
|----------|--------|---------|
| **Initialization code** (need data before continuing) | `ig.callback.Await()` | `local data = ig.callback.Await('Server:GetData')` |
| **Event handler** (process data when ready) | `ig.callback.Async()` | `ig.callback.Async('Server:GetData', callback)` |
| **Low-level control** (rare) | `TriggerServerCallback()` | `TriggerServerCallback({...})` |
| **With timeout handling** | `ig.callback.AwaitWithTimeout()` or `AsyncWithTimeout()` | `ig.callback.AwaitWithTimeout('Server:Data', 5, timeoutCb)` |

---

## Server-Side Registration

When registering callbacks on the server, use the proper format:

```lua
-- ✅ CORRECT: Server callback registration
RegisterServerCallback({
    eventName = "GetInitializationData",
    eventCallback = function(source, args)
        -- source = player ID
        -- args = table of arguments from client
        
        local items = exports['ingenium.sql']:query("SELECT * FROM items")
        local doors = exports['ingenium.sql']:query("SELECT * FROM doors")
        
        return {
            items = items,
            doors = doors,
            -- ... other data
        }
    end
})

-- ✅ USING WRAPPER (Recommended)
ig.callback.RegisterServer("GetInitializationData", function(source, args)
    -- Same logic as above
    return initDataTable
end)
```

---

## Troubleshooting

### "Server callback never received"

**Checklist:**
1. ✅ Using `callback = function(...)` (not positional argument)
2. ✅ Event name matches exactly (case-sensitive)
3. ✅ Server has `RegisterServerCallback` for that event name
4. ✅ Server callback file is loaded before client tries to call it
5. ✅ Check FiveM console for callback registration messages

### "Callback returns nil"

**Possible causes:**
- Server callback isn't returning anything → Add `return` statement
- Server callback is registering but not being triggered → Check event name
- Using `Await()` on async handler → Use `Async()` instead

### "Callback times out"

**Possible causes:**
- Server is slow/blocking → Optimize query or use async database
- Server callback isn't registered → Check server logs
- Database query failing → Add error handling

---

## Documentation Files

Related documentation:
- [Callback_Wrapper_Guide.md](Callback_Wrapper_Guide.md) - Detailed wrapper API
- [Callbacks.md](Callbacks.md) - Low-level callback system overview
- [EVENTS_REFERENCE.md](wiki/EVENTS_REFERENCE.md) - All registered server callbacks

---

## Key Takeaway

> **Always use `callback = function(...)`** as a **named parameter** within the args table, not as a positional argument. The callback system relies on the named parameter format to properly route responses.

