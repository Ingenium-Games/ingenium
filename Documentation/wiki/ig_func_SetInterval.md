# ig.func.SetInterval

## Description

Creates a repeating timer that executes a callback function at specified intervals (in milliseconds). Returns an interval ID that can be used to modify or clear the interval. Similar to JavaScript setInterval.

## Signature

```lua
function ig.func.SetInterval(callback, interval, ...)
```

## Parameters

- **`str`**: any
- **`time`**: any
- **`callback`**: function | number
- **`interval?`**: number
- **`...`**: any

## Example

```lua
-- Example 1: Simple repeating task every second
local intervalId = ig.func.SetInterval(function()
    print("This runs every second")
end, 1000)

-- Example 2: Interval with parameters
local intervalId2 = ig.func.SetInterval(function(playerName, score)
    print(playerName, "score is", score)
end, 5000, "John", 100)

-- Example 3: Dynamic interval adjustment
local myInterval = ig.func.SetInterval(function()
    print("Running...")
end, 2000)

-- Later, change the interval speed
ig.func.SetInterval(myInterval, 500)  -- Now runs every 500ms

-- Example 4: Clean up interval when done
ig.func.ClearInterval(intervalId)
```

## Important Notes

> 📋 **Parameter**: `callback` - Function to execute upon completion

## Related Functions

- [ig.func.Alert](ig_func_Alert.md)
- [ig.func.ClearInterval](ig_func_ClearInterval.md)
- [ig.func.CompareCoords](ig_func_CompareCoords.md)
- [ig.func.CreateObject](ig_func_CreateObject.md)
- [ig.func.CreatePed](ig_func_CreatePed.md)

## Source

Defined in: `server/_functions.lua`
