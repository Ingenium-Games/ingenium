# ig.callback.AsyncWithTimeout

## Description

Performs asyncwithtimeout operation

## Signature

```lua
function ig.callback.AsyncWithTimeout(eventName, timeout, callback, timeoutCallback, ...)
```

## Parameters

- **`eventName`**: any
- **`timeout`**: any
- **`callback`**: function
- **`timeoutCallback`**: any
- **`...`**: any

## Example

```lua
-- Example usage
local result = ig.callback.AsyncWithTimeout(value, value, function() end, value, value)
```

## Source

Defined in: `client/_callback.lua`
