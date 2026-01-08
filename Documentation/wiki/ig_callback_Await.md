# ig.callback.Await

## Description

Synchronously awaits a server callback and returns the result. This blocks execution until the server responds. Use for operations that need immediate results.

## Signature

```lua
function ig.callback.Await(eventName, ...)
```

## Parameters

- **`eventName`**: string The name of the server callback to trigger
- **`...`**: any Additional arguments to pass to the callback

## Example

```lua
-- Example 1: Simple callback with return value
local playerData = ig.callback.Await("getPlayerInfo", source)
print("Player name:", playerData.name)

-- Example 2: Callback with multiple arguments
local bankBalance = ig.callback.Await("getBankBalance", source, accountType)
print("Balance:", bankBalance)

-- Example 3: Using callback result in conditional
local hasPermission = ig.callback.Await("checkPermission", source, "admin.vehicles")
if hasPermission then
    -- Grant access
    print("Permission granted")
else
    print("Permission denied")
end
```

## Related Functions

- [ig.callback.Async](ig_callback_Async.md)
- [ig.callback.AsyncClient](ig_callback_AsyncClient.md)
- [ig.callback.AsyncWithTimeout](ig_callback_AsyncWithTimeout.md)
- [ig.callback.AwaitClient](ig_callback_AwaitClient.md)
- [ig.callback.AwaitWithTimeout](ig_callback_AwaitWithTimeout.md)

## Source

Defined in: `client/_callback.lua`
