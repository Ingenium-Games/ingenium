# ig.func.Debug_2

## Description

Debug logging function for level 2 (warning level) messages. Outputs debug information when debug mode is enabled. Used for non-critical warnings and informational messages.

## Signature

```lua
function ig.func.Debug_2(str)
```

## Parameters

- **`str`**: string

## Example

```lua
-- Log warning level debug message
ig.func.Debug_2("Player attempted invalid action")
ig.func.Debug_2("Cache miss for vehicle data")
```

## Source

Defined in: `client/_functions.lua`
