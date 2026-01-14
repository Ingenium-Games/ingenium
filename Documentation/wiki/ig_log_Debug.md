# ig.log.Debug(tag, fmt, ...)

**Parameters**: 
- `tag` (string) - Message tag/category
- `fmt` (string) - Format string
- `...` (any) - Format arguments

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [S C]

## Description

Log a debug-level message with tag and formatted text. Debug messages are displayed based on configured logging level (equivalent to conf.debug_2).

## Usage

```lua
ig.log.Debug("CALLBACK", "Processing callback: %s", callbackName)
ig.log.Debug("STATE", "Current state: %s -> %s", oldState, newState)
```

## Parameters

### tag (string)
Category/tag for the message (e.g., "CALLBACK", "STATE", "PROCESSING")

### fmt (string)
Format string (supports standard Lua string.format patterns)

### ... (any)
Arguments to substitute in the format string

## Examples

```lua
-- Debug state transitions
ig.log.Debug("STATE", "Entering state: %s", stateName)

-- Debug function calls
ig.log.Debug("CALLBACK", "Callback %s executed in %.2fms", callbackName, duration)

-- Debug data processing
ig.log.Debug("INVENTORY", "Processing %d items for player %d", itemCount, playerId)
```

## See Also

- [ig.log.Error](ig_log_Error.md) - Error-level logging
- [ig.log.Warn](ig_log_Warn.md) - Warn-level logging
- [ig.log.Info](ig_log_Info.md) - Info-level logging
- [ig.log.Trace](ig_log_Trace.md) - Trace-level logging
- [ig.log.Log](ig_log_Log.md) - Generic logging function
