# ig.log.Error(tag, fmt, ...)

**Parameters**: 
- `tag` (string) - Message tag/category
- `fmt` (string) - Format string
- `...` (any) - Format arguments

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [S C]

## Description

Log an error-level message with tag and formatted text. Error messages are always displayed regardless of logging level.

## Usage

```lua
ig.log.Error("PLAYER", "Failed to load player: %s", playerName)
ig.log.Error("DATABASE", "Query failed with code: %d", errorCode)
```

## Parameters

### tag (string)
Category/tag for the message (e.g., "PLAYER", "DATABASE", "VEHICLE")

### fmt (string)
Format string (supports standard Lua string.format patterns)

### ... (any)
Arguments to substitute in the format string

## Examples

```lua
-- Simple error
ig.log.Error("INIT", "Configuration file not found")

-- Formatted error with arguments
ig.log.Error("PLAYER", "Player %d (%s) failed to connect", playerId, playerName)

-- Error with multiple arguments
ig.log.Error("DATABASE", "Query failed: %s (code: %d)", errorMessage, errorCode)
```

## See Also

- [ig.log.Warn](ig_log_Warn.md) - Warn-level logging
- [ig.log.Info](ig_log_Info.md) - Info-level logging
- [ig.log.Debug](ig_log_Debug.md) - Debug-level logging
- [ig.log.Trace](ig_log_Trace.md) - Trace-level logging
- [ig.log.Log](ig_log_Log.md) - Generic logging function
