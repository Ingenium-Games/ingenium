# ig.queue.HandleConnection

## Description

Main queue connection handler that manages player connections with priority processing, connection steps validation, and queue management.

## Signature

```lua
function ig.queue.HandleConnection(src, name, setKickReason, deferrals)
```

## Parameters

- **`src`**: number - Player source ID
- **`name`**: string - Player name
- **`setKickReason`**: function - Function to set kick reason
- **`deferrals`**: table - FiveM deferrals object

## Returns

None

## Behavior

- Validates player identifiers
- Checks ban status
- Processes Discord priority
- Manages queue position
- Executes connection steps
- Handles player admission to server

## Example

```lua
-- This function is typically called automatically by FiveM
-- Manual invocation is not recommended
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    ig.queue.HandleConnection(source, name, setKickReason, deferrals)
end)
```

## Source

Defined in: `server/[Third Party]/_queue_system.lua`
