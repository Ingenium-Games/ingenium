# ig.callback.Await

## Description

Synchronously awaits a server callback and returns the result. This blocks execution until the server responds. Use for operations that need immediate results.

## Signature

```lua
function ig.callback.Await(eventName, ...)
```

## Parameters

- **`eventName`**: any
- **`...`**: any

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

## Source

Defined in: `client/_callback.lua`
