# Issue: Missing `ig.callback.Await` Wrapper Function

## Summary
Multiple files in the codebase use `ig.callback.Await()` which does not exist as a globally registered function. This was likely introduced by an AI code commit without proper validation against the existing callback system architecture.

## Current State

### What Exists
The callback system (`shared/[Third Party]/_callbacks.lua`) provides:
- `TriggerServerCallback(args)` - Client-side function that triggers server callbacks
- `TriggerClientCallback(args)` - Both server and client-side function
- Returns promises when `callback` parameter is omitted
- Supports synchronous await via `Citizen.Await(promise)`

### What's Missing
- No `ig.callback` namespace initialization
- No `ig.callback.Await()` wrapper function
- No convenience methods for common callback patterns

## Files Affected

### Client-Side Files Using `ig.callback.Await`:
1. `client\_appearance.lua` (line 21)
   - `appearanceConstants = ig.callback.Await('ig:GameData:GetAppearanceConstants')`

2. `client\[Data]\_game_data_helpers.lua` (multiple locations)
   - Lines 23, 34, 55, 95, 109, 140, 151
   - Used for tattoos, weapons, vehicles, modkits data fetching

3. `client\[Callbacks]\_appearance.lua` (multiple locations)  
   - Lines 32, 38, 44
   - Used for peds, tattoos, pricing data

### Correct Pattern Currently in Use
Other files correctly use the global `TriggerServerCallback`:
```lua
local items = TriggerServerCallback({eventName = "GetItems", args = {}})
```

## Root Cause
The `ig.callback.Await` syntax appears to be a convenience wrapper that was suggested but never implemented. The global callback functions exist, but they were never wrapped into the `ig.callback` namespace.

## Proposed Solution

### Option 1: Create `ig.callback` Namespace Wrapper (Recommended)
Create a new file `client\_callback.lua` or add to existing initialization that provides:

```lua
ig.callback = ig.callback or {}

---Await a server callback response synchronously
---@param eventName string The name of the server callback to trigger
---@param ... any Additional arguments to pass to the callback
---@return any The result from the server callback
function ig.callback.Await(eventName, ...)
    return TriggerServerCallback({
        eventName = eventName,
        args = {...}
    })
end

---Await a server callback with timeout support
---@param eventName string The name of the server callback
---@param timeout number Timeout in seconds
---@param timeoutCallback function Function to call on timeout
---@param ... any Additional arguments
---@return any The result from the server callback or nil on timeout
function ig.callback.AwaitWithTimeout(eventName, timeout, timeoutCallback, ...)
    return TriggerServerCallback({
        eventName = eventName,
        args = {...},
        timeout = timeout,
        timedout = timeoutCallback
    })
end

---Trigger async server callback with response handler
---@param eventName string The name of the server callback
---@param callback function Function to handle the response
---@param ... any Additional arguments
function ig.callback.Async(eventName, callback, ...)
    TriggerServerCallback({
        eventName = eventName,
        args = {...},
        callback = callback
    })
end
```

### Option 2: Refactor All Usages (Alternative)
Replace all `ig.callback.Await()` calls with direct `TriggerServerCallback()` calls:

**Before:**
```lua
local data = ig.callback.Await('ig:GameData:GetTattoos')
```

**After:**
```lua
local data = TriggerServerCallback({
    eventName = 'ig:GameData:GetTattoos',
    args = {}
})
```

## Implementation Priority

**HIGH** - This is a critical issue because:
1. Code using `ig.callback.Await` will fail at runtime
2. Multiple core systems are affected (appearance, game data)
3. Creates confusion about the proper callback API usage
4. Inconsistent with the rest of the codebase

## Recommended Action

1. ✅ Create `ig.callback` namespace wrapper (Option 1)
2. Update affected files to use proper syntax or keep using wrapper
3. Add to documentation with clear examples
4. Add to code review checklist to prevent future AI-generated inconsistencies

## Testing Requirements

After implementation, verify:
- [ ] All appearance system callbacks work correctly
- [ ] Game data helpers (tattoos, weapons, vehicles, modkits) fetch correctly
- [ ] No console errors related to undefined `ig.callback`
- [ ] Callback timeout and error handling works as expected
- [ ] Performance impact is minimal (wrapper adds negligible overhead)

## Documentation Updates Needed

Update `Documentation/Callbacks.md` to include:
- `ig.callback` namespace documentation
- Examples using both wrapper and direct `TriggerServerCallback`
- Best practices for callback usage patterns
- Migration guide for existing code

---

**Issue Created:** 2026-01-03  
**Severity:** High  
**Category:** Architecture / API Consistency  
**Estimated Effort:** 2-4 hours (implementation + testing + documentation)
